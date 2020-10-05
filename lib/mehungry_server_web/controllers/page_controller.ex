defmodule MehungryServerWeb.PageController do
  use MehungryServerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
