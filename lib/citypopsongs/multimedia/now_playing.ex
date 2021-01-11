defmodule Citypopsongs.Multimedia.NowPlaying do
  use GenServer
  require Logger
  alias Citypopsongs.Multimedia

  @name __MODULE__

  # Client methods
  def start_link(_) do
    GenServer.start_link(@name, initialize_state(), name: @name)
  end

  def get_track() do
    GenServer.call(@name, :now_playing)
  end

  # Server methods
  @impl true
  def init(state) do
    %{radio_track: radio_track} = state
    await_track_completion(radio_track.seconds)
    Logger.info "Initializing live radio with track id #{radio_track.id}"
    {:ok, state}
  end

  @impl true
  def handle_call(:now_playing, _, state) do
    %{radio_track: radio_track} = state
    track = Multimedia.get_track!(radio_track.id)
    response = %{
      track: track,
      start_at: radio_track.start_at,
      end_at: radio_track.end_at
    }
    {:reply, response, state}
  end

  @impl true
  def handle_info(:play_next_track, %{shuffled_ids: []}) do
    state = initialize_state()
    %{radio_track: next_track, shuffled_ids: shuffled_ids} = state
    [_ | tail] = shuffled_ids

    Logger.info "Playing next radio track #{next_track.id}"
    await_track_completion(next_track.seconds)

    {:noreply, %{radio_track: next_track, shuffled_ids: tail}}
  end

  @impl true
  def handle_info(:play_next_track, %{shuffled_ids: ids}) do
    [next_id | tail] = ids

    radio_track =
      next_id
      |> Multimedia.get_track!()
      |> initialize_radio_track()

    Logger.info "Playing next radio track #{radio_track.id}"
    await_track_completion(radio_track.seconds)

    {:noreply, %{radio_track: radio_track, shuffled_ids: tail}}
  end

  defp initialize_state do
    track_ids =
      1..Multimedia.count_tracks()
      |> Enum.to_list
      |> Enum.shuffle

    [_ | tail] = track_ids

    radio_track =
      track_ids
      |> List.first
      |> Multimedia.get_track!
      |> initialize_radio_track()

    %{
      radio_track: radio_track,
      shuffled_ids: tail,
    }
  end

  defp initialize_radio_track(track) do
    start_at = System.system_time(:second)
    end_at = start_at + track.seconds
    %{
      id: track.id,
      seconds: track.seconds,
      start_at: start_at,
      end_at: end_at,
    }
  end

  defp await_track_completion(track_length) do
    Process.send_after(self(), :play_next_track, track_length * 1000)
  end
end
