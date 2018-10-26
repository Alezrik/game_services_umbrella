defmodule Mix.Tasks.Kubernetes do
  use Mix.Task

  @moduledoc """

    * mix kubernetes start_minikube - starts minikube
    * mix kubernetes create_auth_user - create kubernetes user
    * mix kubernetes create_secrets - create secrets in kubernetes
    * mix kubernetes create_headless - create headless service in kubernetes
    * mix kubernetes create_service - create external loadbalancer service in kubernetes
    * mix kubernetes deploy - deploy :latest tag to kubernetes

  """

  @shortdoc "Functions for Kubernetes"
  def run(args) do
    IO.puts(inspect(args))

    case List.first(args) do
      "start_minikube" ->
        execute_shell_with_output("minikube start")

      "create_auth_user" ->
        execute_shell_with_output(
          "kubectl create clusterrolebinding --user system:serviceaccount:default:default default-sa-admin --clusterrole cluster-admin"
        )

      "create_secrets" ->
        execute_shell_with_output("kubectl create -f k8s/game_services_umbrella-secrets.yaml")

      "create_headless" ->
        execute_shell_with_output("kubectl create -f k8s/game_services_umbrella-headless.yaml")

      "create_service" ->
        execute_shell_with_output("kubectl create -f k8s/game_services_umbrella-service.yaml")

      "deploy" ->
        execute_shell_with_output("kubectl create -f k8s/game_services_umbrella-deployment.yaml")
    end
  end

  defp execute_shell_with_output(cmd) when is_binary(cmd) do
    shell_cmd = String.split(cmd, " ")
    execute_shell_with_output(List.first(shell_cmd), Enum.drop(shell_cmd, 1))
  end

  defp execute_shell_with_output(cmd, params) when is_list(params) do
    System.cmd(cmd, params, into: IO.stream(:stdio, :line))
  end
end
