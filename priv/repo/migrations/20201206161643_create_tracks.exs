defmodule Citypopsongs.Repo.Migrations.CreateTracks do
  use Ecto.Migration

  def change do
    create table(:tracks) do
      add :title, :string
      add :slug, :string
      add :artist, :string

      timestamps()
    end
    create unique_index(:tracks, [:title])
  end
end
