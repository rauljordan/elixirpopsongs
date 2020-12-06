defmodule CitypopsongsWeb.LandingController do
  use CitypopsongsWeb, :controller

  def about(conn, _params) do
    render(conn, "about.html")
  end

  def privacy_policy(conn, _params) do
    render(conn, "privacy_policy.html")
  end

  def terms_of_use(conn, _params) do
    render(conn, "terms_of_use.html")
  end
end
