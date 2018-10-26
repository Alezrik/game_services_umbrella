defmodule Mix.Tasks.Docker do
  use Mix.Task

  @moduledoc """
  * mix docker clean - cleans all docker containers and images
  * mix docker start_local_registry - download and start a local docker registry on port 5000
  * mix docker get_base_docker - download base docker image to local_registry
  * mix docker build_builder - build the docker used for building release packages and push to local registry
  * mix docker build_umbrella - build newest release and push to local registry
  * mix docker build_release - builds release docker
  """

  @shortdoc "Various docker tasks"
  def run(args) do
    IO.puts("#{inspect(args)}")

    case List.first(args) do
      "clean" ->
        {res, _result} = execute_shell("docker ps -q")

        String.split(res, "\n")
        |> Enum.filter(fn x -> String.length(x) > 0 end)
        |> Enum.each(fn x -> execute_shell_with_output("docker kill #{x}") end)

        {res, _result} = execute_shell("docker ps -a -q")

        String.split(res, "\n")
        |> Enum.filter(fn x -> String.length(x) > 0 end)
        |> Enum.each(fn x -> execute_shell_with_output("docker rm #{x} --force") end)

        {res, _result} = execute_shell("docker images -q")

        String.split(res, "\n")
        |> Enum.filter(fn x -> String.length(x) > 0 end)
        |> Enum.each(fn x -> execute_shell_with_output("docker rmi #{x} --force") end)

      "get_base_docker" ->
        execute_shell_with_output("docker pull elixir:1.7.3")
        execute_shell_with_output("docker tag elixir:1.7.3 localhost:5000/elixir:1.7.3")
        execute_shell_with_output("docker push localhost:5000/elixir:1.7.3")
        execute_shell_with_output("docker rmi elixir:1.7.3")

      "start_local_registry" ->
        execute_shell_with_output(
          "docker run -d -p 5000:5000 --restart=always --name registry registry:2"
        )

      "build_builder" ->
        execute_shell_with_output(
          "docker build -t localhost:5000/game_services_umbrella:build . --file ./Dockerfile.builder.build"
        )

        execute_shell_with_output("docker push localhost:5000/game_services_umbrella:build")

      "build_umbrella" ->
        execute_shell_with_output(
          "docker build -t localhost:5000/game_services_umbrella:#{get_version()} . --file ./Dockerfile.umbrella.build"
        )

        execute_shell_with_output(
          "docker push localhost:5000/game_services_umbrella:#{get_version()}"
        )

        execute_shell_with_output(
          "docker tag localhost:5000/game_services_umbrella:#{get_version()} localhost:5000/game_services_umbrella:latest"
        )

        execute_shell_with_output("docker push localhost:5000/game_services_umbrella:latest")

      "build_release" ->
        execute_shell_with_output("rm game_services_umbrella.tar.gz")

        execute_shell_with_output(
          "docker create --name game_services_umbrella-build localhost:5000/game_services_umbrella:latest"
        )

        execute_shell_with_output(
          "docker cp game_services_umbrella-build:/opt/app/_build/prod/rel/game_services_umbrella/releases/#{
            get_version()
          }/game_services_umbrella.tar.gz ./"
        )

        execute_shell_with_output("docker rm game_services_umbrella-build --force")

        execute_shell_with_output(
          "docker build -t localhost:5000/game_services_umbrella:release . --file ./Dockerfile.release"
        )

        execute_shell_with_output("docker push localhost:5000/game_services_umbrella:release")

      _other ->
        IO.puts("invalid command")
    end
  end

  defp execute_shell(cmd) when is_binary(cmd) do
    shell_cmd = String.split(cmd, " ")
    execute_shell(List.first(shell_cmd), Enum.drop(shell_cmd, 1))
  end

  defp execute_shell(cmd, params) when is_list(params) do
    System.cmd(cmd, params)
  end

  defp execute_shell_with_output(cmd) when is_binary(cmd) do
    shell_cmd = String.split(cmd, " ")
    execute_shell_with_output(List.first(shell_cmd), Enum.drop(shell_cmd, 1))
  end

  defp execute_shell_with_output(cmd, params) when is_list(params) do
    System.cmd(cmd, params, into: IO.stream(:stdio, :line))
  end

  defp get_version() do
    File.read!("mix.exs")
    |> String.split("\n")
    |> Enum.filter(fn x -> String.contains?(x, "version") end)
    |> Enum.flat_map(fn x -> String.split(x, " ") end)
    |> Enum.filter(fn x ->
      String.length(x) > 0 && String.contains?(x, "version") == false
    end)
    |> Enum.map(fn x -> String.replace(x, "\"", "") end)
    |> Enum.map(fn x -> String.replace(x, ",", "") end)
    |> List.first()
  end
end
