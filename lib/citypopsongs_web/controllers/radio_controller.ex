defmodule CitypopsongsWeb.RadioController do
  use CitypopsongsWeb, :controller

  def index(conn, params) do
    render(conn, "index.html")
  end
end
