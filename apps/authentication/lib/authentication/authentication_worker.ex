defmodule Authentication.AuthenticationWorker do
  @moduledoc false

  use GenServer
  require Logger

  def start_link(_) do
    {:ok, pid} = Swarm.register_name(__MODULE__, __MODULE__, :register, [])
    Swarm.join(:authenticate, pid)
    {:ok, pid}
  end

  @impl true
  def init(_) do
    {:ok, :ok}
  end

  def register() do
    GenServer.start_link(__MODULE__, name: __MODULE__)
  end

  @impl true
  def handle_call({:authenticate, username, password}, _from, state) do
    {:reply, GameServices.Identity.get_user_by_credential_name_and_password(username, password),
     state}
  end
end
