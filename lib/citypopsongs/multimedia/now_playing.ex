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
    GenServer.start_link(@name, {first_track, starting_at, ending_at}, name: @name)
  end

  def get_track() do
    GenServer.call(@name, :now_playing)
  end

  # Server methods
  @impl true
  def init(state) do
    {track, _, _} = state
    await_track_completion(track.seconds)
    Logger.info "Initializing live radio with track #{track.title}"
    {:ok, state}
  end

  @impl true
  def handle_call(:now_playing, _, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info(:play_next_track, _) do
    next_track = Multimedia.get_random_track()
    Logger.info "Playing next radio track #{next_track.title}"
    starting_at = System.system_time(:second)
    ending_at = starting_at + next_track.seconds
    await_track_completion(next_track.seconds)
    {:noreply, {next_track, starting_at, ending_at}}
  end

  defp await_track_completion(track_length) do
    Process.send_after(self(), :play_next_track, track_length * 1000)
  end
end
