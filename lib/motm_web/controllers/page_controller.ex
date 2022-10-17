defmodule MotmWeb.PageController do
  use MotmWeb, :controller

  plug :put_layout, false when action in [:home]

  def home(conn, _params) do
    render(conn, "home.html")
  end
end
