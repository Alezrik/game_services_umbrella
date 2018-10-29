defmodule GameServicesWeb.Router do
  @moduledoc false
  use GameServicesWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GameServicesWeb do
    pipe_through :browser

    resources "/credentials", CredentialController
    resources "/users", UserController
    get "/", PageController, :index
    get "/login", LoginController, :index
    post "/login", LoginController, :login
    get "/registration", RegistrationController, :index
    post "/registration", RegistrationController, :register
  end

  # Other scopes may use custom stacks.
  # scope "/api", GameServicesWeb do
  #   pipe_through :api
  # end
end
