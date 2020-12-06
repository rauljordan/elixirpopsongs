defmodule Citypopsongs.Repo do
  use Ecto.Repo,
    otp_app: :citypopsongs,
    adapter: Ecto.Adapters.Postgres
end
