defmodule CitypopsongsWeb.NowPlayingChannel do
  use CitypopsongsWeb, :channel
  alias Citypopsongs.Multimedia
  require Logger

  @impl true
  def join("now_playing:lobby", _payload, socket) do
    Logger.info "join join"
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", _payload, socket) do
    Logger.info "Pinged"
    %{track: track, start_at: start_at, end_at: end_at} =
      Multimedia.NowPlaying.get_track()
    Multimedia.increase_listens(track)
    Logger.error "attempting ping"
    {:reply, {:ok,
      %{
        slug: track.slug,
        title: track.title,
        artist: track.artist,
        seconds: track.seconds,
        listens: track.listens,
        start_at: start_at,
        end_at: end_at
      }
    }, socket}
  end
end
