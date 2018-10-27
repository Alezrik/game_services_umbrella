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
    case List.first(args) do
      "clean" ->
        {res, _result} = execute_shell("docker ps -q")

        res
        |> String.split("\n")
        |> Enum.filter(fn x -> String.length(x) > 0 end)
        |> Enum.each(fn x ->
          {:ok, res, result} = execute_shell_with_output("docker kill #{x}")
        end)

        {res, _result} = execute_shell("docker ps -a -q")

        res
        |> String.split("\n")
        |> Enum.filter(fn x -> String.length(x) > 0 end)
        |> Enum.each(fn x ->
          {:ok, res, result} = execute_shell_with_output("docker rm #{x} --force")
        end)

        {res, _result} = execute_shell("docker images -q")

        res
        |> String.split("\n")
        |> Enum.filter(fn x -> String.length(x) > 0 end)
        |> Enum.each(fn x ->
          {:ok, res, result} = execute_shell_with_output("docker rmi #{x} --force")
        end)

      "get_base_docker" ->
        {:ok, res, result} = execute_shell_with_output("docker pull elixir:1.7.3")

        {:ok, res, result} =
          execute_shell_with_output("docker tag elixir:1.7.3 127.0.0.1:5000/elixir:1.7.3")

        {:ok, res, result} = execute_shell_with_output("docker push 127.0.0.1:5000/elixir:1.7.3")
        {:ok, res, result} = execute_shell_with_output("docker rmi elixir:1.7.3")

      "start_local_registry" ->
        {:ok, res, result} = execute_shell_with_output("kubectl create -f k8s/kube-registry.yaml")

      "build_builder" ->
        {:ok, res, result} =
          execute_shell_with_output(
            "docker build -t 127.0.0.1:5000/game_services_umbrella:build . --file ./Dockerfile.builder.build"
          )

        {:ok, res, result} =
          execute_shell_with_output("docker push 127.0.0.1:5000/game_services_umbrella:build")

      "build_umbrella" ->
        {:ok, res, result} =
          execute_shell_with_output("docker pull 127.0.0.1:5000/game_services_umbrella:build")

        {:ok, res, result} =
          execute_shell_with_output(
            "docker build -t 127.0.0.1:5000/game_services_umbrella:#{get_version()} . --file ./Dockerfile.umbrella.build"
          )

        {:ok, res, result} =
          execute_shell_with_output(
            "docker push 127.0.0.1:5000/game_services_umbrella:#{get_version()}"
          )

        {:ok, res, result} =
          execute_shell_with_output(
            "docker tag 127.0.0.1:5000/game_services_umbrella:#{get_version()} 127.0.0.1:5000/game_services_umbrella:compile"
          )

        {:ok, res, result} =
          execute_shell_with_output("docker push 127.0.0.1:5000/game_services_umbrella:compile")

      "build_release" ->
        {:ok, res, result} = execute_shell_with_output("rm game_services_umbrella.tar.gz")

        {:ok, res, result} =
          execute_shell_with_output(
            "docker create --name game_services_umbrella-build 127.0.0.1:5000/game_services_umbrella:compile"
          )

        {:ok, res, result} =
          execute_shell_with_output(
            "docker cp game_services_umbrella-build:/opt/app/_build/prod/rel/game_services_umbrella/releases/#{
              get_version()
            }/game_services_umbrella.tar.gz ./"
          )

        {:ok, res, result} =
          execute_shell_with_output("docker rm game_services_umbrella-build --force")

        {:ok, res, result} =
          execute_shell_with_output(
            "docker build -t 127.0.0.1:5000/game_services_umbrella:release . --file ./Dockerfile.release"
          )

        {:ok, res, result} =
          execute_shell_with_output("docker push 127.0.0.1:5000/game_services_umbrella:release")

      _other ->
        IO.puts("invalid command")
    end
  end

  defp execute_shell(cmd) when is_binary(cmd) do
    shell_cmd = String.split(cmd, " ")
    execute_shell(List.first(shell_cmd), Enum.drop(shell_cmd, 1))
  end

  defp execute_shell(cmd, params) when is_list(params) do
    {res, result} = System.cmd(cmd, params)

    case result do
      0 -> {res, result}
      other -> {:error}
    end
  end

  defp execute_shell_with_output(cmd) when is_binary(cmd) do
    shell_cmd = String.split(cmd, " ")
    execute_shell_with_output(List.first(shell_cmd), Enum.drop(shell_cmd, 1))
  end

  defp execute_shell_with_output(cmd, params) when is_list(params) do
    {res, result} = System.cmd(cmd, params, into: IO.stream(:stdio, :line))

    case result do
      0 -> {:ok, res, result}
      other -> {:error}
    end
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
