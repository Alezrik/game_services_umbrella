defmodule GameServicesWeb.RegistrationController do
  @moduledoc false
  use GameServicesWeb, :controller
  require Logger

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def register(conn, %{"register" => user_params}) do
    case UserManager.register_new_user(
           Map.get(user_params, "username"),
           Map.get(user_params, "email"),
           Map.get(user_params, "password")
         ) do
      {:ok, user} ->
        Logger.info(fn -> "User Registration Success" end, user_id: user.id)
        redirect(conn, to: Routes.page_path(conn, :index))

      {:error, :create_credential, changeset, _other} ->
        err = Enum.map(changeset.errors, fn x -> get_errors_text(x) end)
        Logger.metadata(register_error: err)
        Logger.warn(fn -> "User Register Error" end)

        conn
        |> put_flash(:register_err, "Invalid Register Credentials - #{Enum.join(err, " , ")} -- ")
        |> render("index.html")

      _other ->
        Logger.error(fn -> "Unknown Error" end)

        conn
        |> put_flash(:register_err, "unknown error")
        |> render("index.html")
    end
  end

  defp get_errors_text({name, {msg, opts}}) do
    if count = opts[:count] do
      "#{name} " <> Gettext.dngettext(GameServicesWeb.Gettext, "errors", msg, msg, count, opts)
    else
      "#{name} " <> Gettext.dgettext(GameServicesWeb.Gettext, "errors", msg, opts)
    end
  end
end
