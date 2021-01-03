defmodule Citypopsongs.Repo.Migrations.AddListensToTracks do
  use Ecto.Migration

  def change do
    alter table(:tracks) do
      add :listens, :integer, default: 0
    end
  end
end
