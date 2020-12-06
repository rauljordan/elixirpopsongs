defmodule CitypopsongsWeb.TrackController do
  use CitypopsongsWeb, :controller

  alias Citypopsongs.Multimedia
  alias Citypopsongs.Multimedia.Track

  def index(conn, params) do
    tracks = Multimedia.list_tracks(params)
    render(conn, "index.html", tracks: tracks)
  end

  def new(conn, _params) do
    changeset = Multimedia.change_track(%Track{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"track" => track_params}) do
    case Multimedia.create_track(track_params) do
      {:ok, track} ->
        conn
        |> put_flash(:info, "Track created successfully.")
        |> redirect(to: Routes.track_path(conn, :show, track))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    track = Multimedia.get_track!(id)
    render(conn, "show.html", track: track)
  end

  def edit(conn, %{"id" => id}) do
    track = Multimedia.get_track!(id)
    changeset = Multimedia.change_track(track)
    render(conn, "edit.html", track: track, changeset: changeset)
  end

  def update(conn, %{"id" => id, "track" => track_params}) do
    track = Multimedia.get_track!(id)

    case Multimedia.update_track(track, track_params) do
      {:ok, track} ->
        conn
        |> put_flash(:info, "Track updated successfully.")
        |> redirect(to: Routes.track_path(conn, :show, track))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", track: track, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    track = Multimedia.get_track!(id)
    {:ok, _track} = Multimedia.delete_track(track)

    conn
    |> put_flash(:info, "Track deleted successfully.")
    |> redirect(to: Routes.track_path(conn, :index))
  end
end
