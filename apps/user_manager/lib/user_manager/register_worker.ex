defmodule UserManager.RegisterWorker do
  @moduledoc false
  use GenServer

  def start_link(_) do
    {:ok, pid} = Swarm.register_name(__MODULE__, __MODULE__, :register, [])
    Swarm.join(:user_register, pid)
    {:ok, pid}
  end

  @impl true
  def init(_) do
    {:ok, :ok}
  end

  def register() do
    GenServer.start_link(__MODULE__, name: __MODULE__)
  end

  def handle_call({:register_user, name, email, password}, _from, state) do
    multi =
      Ecto.Multi.new()
      |> Ecto.Multi.run(:create_user, __MODULE__, :create_user, [])
      |> Ecto.Multi.run(:create_credential, __MODULE__, :create_credential, [
        name,
        email,
        password
      ])
      |> Ecto.Multi.run(:get_user, __MODULE__, :get_user, [])

    task =
      Task.Supervisor.async(UserManager.TaskSupervisor, fn ->
        case GameServices.Repo.transaction(multi) do
          {:ok, credential} ->
            user = Map.get(credential, :get_user)
            {:reply, {:ok, user}, state}

          other ->
            {:reply, other, state}
        end
      end)

    Task.await(task)
  end

  def create_user(_a, _b) do
    GameServices.Account.create_user(%{})
  end

  def create_credential(_repo, user, name, email, password) do
    GameServices.Identity.create_credential(%{
      name: name,
      email: email,
      password: password,
      user_id: Map.get(user, :create_user).id
    })
  end

  def get_user(_repo, prev) do
    {:ok, Map.get(prev, :create_user)}
  end
end
