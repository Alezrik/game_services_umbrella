defmodule UserManager.RegisterWorker do
  @moduledoc false
  use GenServer
  require Logger

  def start_link(_) do
    ClusterManager.start_cluster_worker(__MODULE__, :register)
  end

  @impl true
  def init(_) do
    {:ok, :ok}
  end

  @impl true
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
            process_create_success(credential, state)

          other ->
            {:reply, other, state}
        end
      end)

    Task.await(task)
  end

  def process_create_success(credential, state) do
    user = Map.get(credential, :get_user)

    Logger.info(fn -> "DB Registration Success" end,
      user_id: user.id,
      username: Map.get(credential, :create_credential).name
    )

    {:reply, {:ok, user}, state}
  end

  def create_user(_a, _b) do
    GameServices.Account.create_user(%{})
  end

  def create_credential(_repo, user, name, email, password) do
    u = Map.get(user, :create_user)
    Logger.debug(fn -> "user is #{inspect(u)}" end)

    GameServices.Identity.create_credential(%{
      name: name,
      email: email,
      password: password,
      user_id: u.id
    })
  end

  def get_user(_repo, prev) do
    {:ok, Map.get(prev, :create_user)}
  end
end
