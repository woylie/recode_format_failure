defmodule NewappWeb.PageController do
  use NewappWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
