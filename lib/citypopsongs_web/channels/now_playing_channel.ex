defmodule CitypopsongsWeb.NowPlayingChannel do
  use CitypopsongsWeb, :channel
  alias Citypopsongs.Multimedia

  @impl true
  def join("now_playing:lobby", _payload, socket) do
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", _payload, socket) do
    IO.puts "Got in"
    random_track = Multimedia.get_random_track()
    {:reply, {:ok, %{slug: random_track.slug, title: random_track.title, artist: random_track.artist}}, socket}
  end
end
