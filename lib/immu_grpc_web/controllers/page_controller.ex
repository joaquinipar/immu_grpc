defmodule ImmuGrpcWeb.PageController do
  use ImmuGrpcWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
