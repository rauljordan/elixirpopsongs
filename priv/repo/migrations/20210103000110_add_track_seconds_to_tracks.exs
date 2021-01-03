defmodule Citypopsongs.Repo.Migrations.AddTrackSecondsToTracks do
  use Ecto.Migration

  def change do
    alter table(:tracks) do
      add :seconds, :integer
    end
  end
end
