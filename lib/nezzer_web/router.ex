defmodule NezzerWeb.Router do
  use NezzerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NezzerWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/noise", NoiseLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", NezzerWeb do
  #   pipe_through :api
  # end
end
