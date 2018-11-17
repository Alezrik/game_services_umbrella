defmodule ClusterManager do
  @moduledoc """
  Handles the cluster or lack there of when running in environments

  set cluster_status in config to true to enable cluster or false (default)
  """

  @cluster_active Application.get_env(:cluster_manager, :cluster_status, false)

  @doc """
    gets the tag to call the Authentication Worker's GenServer
  """
  @spec get_authentication_worker(boolean()) :: {atom(), atom(), module()} | module()
  def get_authentication_worker(get_swarm \\ @cluster_active) do
    get_gensever_name(Authentication.AuthenticationWorker, get_swarm)
  end

  @doc """
    gets the tag to callt he Registration Worker's GenServer
  """
  @spec get_registration_worker(boolean()) :: {atom(), atom(), module()} | module()
  def get_registration_worker(get_swarm \\ @cluster_active) do
    get_gensever_name(UserManager.RegisterWorker, get_swarm)
  end

  @doc """
    gets the tag to call the TcpCommandProcessor's GenServer
  """
  @spec get_tcp_command_processor(boolean()) :: {atom(), atom(), module()} | module()
  def get_tcp_command_processor(get_swarm \\ @cluster_active) do
    get_gensever_name(TcpServer.TcpCommandProcessor, get_swarm)
  end

  @doc """
    gets the tag to call the TcpClient's GenServer
  """
  @spec get_tcp_client(boolean()) :: {atom(), atom(), module()} | module()
  def get_tcp_client(get_swarm \\ @cluster_active) do
    get_gensever_name(TcpServer.TcpClient, get_swarm)
  end

  @doc """
    starts a GenServer normally or through Swarm depending on ClusterStatus
  """
  @spec start_cluster_worker(module(), atom(), list(), boolean()) ::
          {:ok, any()} | {:error, any()}

  def start_cluster_worker(
        name,
        cluster_group,
        genserver_opts \\ [],
        start_swarm \\ @cluster_active
      ) do
    case start_swarm do
      true ->
        {:ok, pid} = Swarm.register_name(name, __MODULE__, :start_genserver, [name])
        Swarm.join(cluster_group, pid)
        {:ok, pid}

      false ->
        start_genserver(name, genserver_opts)
    end
  end

  @doc """
    Starts a GenServer
  """
  @spec start_genserver(module(), list()) :: {:ok, any()} | {:error, any()}
  def start_genserver(name, opts \\ []) do
    GenServer.start_link(name, opts, name: name)
  end

  @spec get_gensever_name(module(), boolean()) :: {atom(), atom(), module()} | module()
  defp get_gensever_name(name, get_swarm) do
    case get_swarm do
      true -> {:via, :swarm, name}
      false -> name
    end
  end
end
