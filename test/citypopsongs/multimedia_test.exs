defmodule Citypopsongs.MultimediaTest do
  use Citypopsongs.DataCase

  alias Citypopsongs.Multimedia

  describe "tracks" do
    alias Citypopsongs.Multimedia.Track

    @valid_attrs %{artist: "some artist", slug: "some slug", title: "some title"}
    @update_attrs %{artist: "some updated artist", slug: "some updated slug", title: "some updated title"}
    @invalid_attrs %{artist: nil, slug: nil, title: nil}

    def track_fixture(attrs \\ %{}) do
      {:ok, track} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Multimedia.create_track()

      track
    end

    test "list_tracks/0 returns all tracks" do
      track = track_fixture()
      assert Multimedia.list_tracks() == [track]
    end

    test "get_track!/1 returns the track with given id" do
      track = track_fixture()
      assert Multimedia.get_track!(track.id) == track
    end

    test "create_track/1 with valid data creates a track" do
      assert {:ok, %Track{} = track} = Multimedia.create_track(@valid_attrs)
      assert track.artist == "some artist"
      assert track.slug == "some slug"
      assert track.title == "some title"
    end

    test "create_track/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Multimedia.create_track(@invalid_attrs)
    end

    test "update_track/2 with valid data updates the track" do
      track = track_fixture()
      assert {:ok, %Track{} = track} = Multimedia.update_track(track, @update_attrs)
      assert track.artist == "some updated artist"
      assert track.slug == "some updated slug"
      assert track.title == "some updated title"
    end

    test "update_track/2 with invalid data returns error changeset" do
      track = track_fixture()
      assert {:error, %Ecto.Changeset{}} = Multimedia.update_track(track, @invalid_attrs)
      assert track == Multimedia.get_track!(track.id)
    end

    test "delete_track/1 deletes the track" do
      track = track_fixture()
      assert {:ok, %Track{}} = Multimedia.delete_track(track)
      assert_raise Ecto.NoResultsError, fn -> Multimedia.get_track!(track.id) end
    end

    test "change_track/1 returns a track changeset" do
      track = track_fixture()
      assert %Ecto.Changeset{} = Multimedia.change_track(track)
    end
  end
end
