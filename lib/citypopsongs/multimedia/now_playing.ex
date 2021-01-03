defmodule Citypopsongs.Multimedia.NowPlaying do
  use GenServer
  require Logger
  alias Citypopsongs.Multimedia

  @name __MODULE__

  # Client methods
  def start_link(_) do
    first_track = Multimedia.get_random_track()
    starting_at = System.system_time(:second)
    ending_at = starting_at + first_track.seconds
    GenServer.start_link(@name, {first_track.id, first_track.seconds, starting_at, ending_at}, name: @name)
  end

  def get_track() do
    GenServer.call(@name, :now_playing)
  end

  # Server methods
  @impl true
  def init(state) do
    {track_id, seconds, _, _} = state
    await_track_completion(seconds)
    Logger.info "Initializing live radio with track id #{track_id}"
    {:ok, state}
  end

  @impl true
  def handle_call(:now_playing, _, state) do
    {track_id, _, starting_at, ending_at} = state
    track = Multimedia.get_track!(track_id)
    {:reply, {track, starting_at, ending_at}, state}
  end

  @impl true
  def handle_info(:play_next_track, _) do
    next_track = Multimedia.get_random_track()
    Logger.info "Playing next radio track #{next_track.title}"
    starting_at = System.system_time(:second)
    ending_at = starting_at + next_track.seconds
    await_track_completion(next_track.seconds)
    {:noreply, {next_track.id, next_track.seconds, starting_at, ending_at}}
  end

  defp await_track_completion(track_length) do
    Process.send_after(self(), :play_next_track, track_length * 1000)
  end
end
