defmodule NezzerWeb.PageController do
  use NezzerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
