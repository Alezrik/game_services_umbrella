defmodule GameServices.Identity do
  require Logger

  @moduledoc """
  The Identity context.
  """

  import Ecto.Query, warn: false
  alias GameServices.Repo

  alias GameServices.Identity.Credential

  @doc """
  Returns the list of credentials.

  ## Examples

      iex> list_credentials()
      [%Credential{}, ...]

  """
  def list_credentials do
    Repo.all(Credential)
  end

  @doc """
  Gets a single credential.

  Raises `Ecto.NoResultsError` if the Credential does not exist.

  ## Examples

      iex> get_credential!(123)
      %Credential{}

      iex> get_credential!(456)
      ** (Ecto.NoResultsError)

  """
  def get_credential!(id), do: Repo.get!(Credential, id)

  @doc """
    get credential by name and password

    returns {:error, "no user"} if no user is found, else {:ok, user}

  """
  def get_user_by_credential_name_and_password(name, password)
      when not is_nil(name) and not is_nil(password) do
    query =
      from c in Credential,
        where: c.name == ^name and c.password == ^password

    case Repo.all(query) do
      [] ->
        {:error, "no user"}

      [resp] ->
        credential = resp |> Repo.preload(:user)
        Logger.debug(fn -> "credential is #{inspect(credential)}" end)
        {:ok, credential.user}
    end
  end

  def get_user_by_credential_name_and_password(_a, _b) do
    {:error, "no user"}
  end

  @doc """
  Creates a credential.

  ## Examples

      iex> create_credential(%{field: value})
      {:ok, %Credential{}}

      iex> create_credential(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_credential(attrs \\ %{}) do
    %Credential{}
    |> Credential.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a credential.

  ## Examples

      iex> update_credential(credential, %{field: new_value})
      {:ok, %Credential{}}

      iex> update_credential(credential, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_credential(%Credential{} = credential, attrs) do
    credential
    |> Credential.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Credential.

  ## Examples

      iex> delete_credential(credential)
      {:ok, %Credential{}}

      iex> delete_credential(credential)
      {:error, %Ecto.Changeset{}}

  """
  def delete_credential(%Credential{} = credential) do
    Repo.delete(credential)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking credential changes.

  ## Examples

      iex> change_credential(credential)
      %Ecto.Changeset{source: %Credential{}}

  """
  def change_credential(%Credential{} = credential) do
    Credential.changeset(credential, %{})
  end
end
