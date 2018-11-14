defmodule IReallyHateExoWeb.Router do
  use IReallyHateExoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", IReallyHateExoWeb do
    pipe_through :api
  end
end
