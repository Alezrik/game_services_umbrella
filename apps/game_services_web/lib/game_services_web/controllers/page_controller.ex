defmodule GameServicesWeb.PageController do
  @moduledoc false
  use GameServicesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
