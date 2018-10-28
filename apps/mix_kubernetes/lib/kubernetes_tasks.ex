defmodule Mix.Tasks.Kubernetes do
  use Mix.Task

  @moduledoc """

    * mix kubernetes start_minikube - starts minikube
    * mix kubernetes create_auth_user - create kubernetes user
    * mix kubernetes create_secrets - create secrets in kubernetes
    * mix kubernetes create_headless - create headless service in kubernetes
    * mix kubernetes create_service - create external loadbalancer service in kubernetes
    * mix kubernetes deploy - deploy :latest tag to kubernetes
    * undeploy - remove deployment from kubernetes
    * upsert-deploy - redeploy or create deployment in kubernetes (will not effect running pods)
  """

  @shortdoc "Functions for Kubernetes"
  def run(args) do
    process_cmd(List.first(args))
  end

  defp process_cmd("status"), do: execute_shell_with_output("kubectl get pods -n kube-system")

  defp process_cmd("create_auth_user"),
    do:
      execute_shell_with_output(
        "kubectl create clusterrolebinding --user system:serviceaccount:default:default default-sa-admin --clusterrole cluster-admin"
      )

  defp process_cmd("start_minikube"), do: execute_shell_with_output("minikube start")

  defp process_cmd("create_secrets"),
    do: execute_shell_with_output("kubectl create -f k8s/game_services_umbrella-secrets.yaml")

  defp process_cmd("create_headless"),
    do: execute_shell_with_output("kubectl create -f k8s/game_services_umbrella-headless.yaml")

  defp process_cmd("create_service"),
    do: execute_shell_with_output("kubectl create -f k8s/game_services_umbrella-service.yaml")

  defp process_cmd("deploy"),
    do: execute_shell_with_output("kubectl create -f k8s/game_services_umbrella-deployment.yaml")

  defp process_cmd("undeploy"),
    do: execute_shell_with_output("kubectl delete -f k8s/game_services_umbrella-deployment.yaml")

  defp process_cmd("upsert-deploy"),
    do: execute_shell_with_output("kubectl apply -f k8s/game_services_umbrella-deployment.yaml")

  defp execute_shell_with_output(cmd) when is_binary(cmd) do
    shell_cmd = String.split(cmd, " ")
    execute_shell_with_output(List.first(shell_cmd), Enum.drop(shell_cmd, 1))
  end

  defp execute_shell_with_output(cmd, params) when is_list(params) do
    System.cmd(cmd, params, into: IO.stream(:stdio, :line))
  end
end
