defmodule UserManager.RegisterWorker do
  @moduledoc """
  handles work for user registration
"""
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
    resp = Ecto.Multi.new
    |> Ecto.Multi.run(:create_user, __MODULE__, :create_user, [])
    |> Ecto.Multi.run(:create_credential, __MODULE__, :create_credential, [name, email, password])
    |> GameServices.Repo.transaction()
    {:reply, resp, state}
  end

  def create_user(_a, _b) do
    GameServices.Account.create_user(%{})
  end

  def create_credential(user, _b, name, email, password) do
    GameServices.Identity.create_credential(%{name: name, email: email, password: password})
  end
end