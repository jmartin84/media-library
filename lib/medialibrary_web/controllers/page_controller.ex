defmodule MedialibraryWeb.PageController do
  use MedialibraryWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
