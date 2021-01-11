defmodule Citypopsongs.Chats.LiveChat do
  use GenServer

  @name __MODULE__
  @fetch_messages_length 50

  # Client methods
  def start_link(_) do
    GenServer.start_link(@name, [], name: @name)
  end

  def get_recent_messages() do
    GenServer.call(@name, :recent_messages)
  end

  def push_message(message) do
    GenServer.call(@name, {:push_message, message})
  end

  # Server methods
  @impl true
  def init(messages) do
    {:ok, messages}
  end

  @impl true
  def handle_call(:recent_messages, _, state) do
    recent =
      state
      |> Enum.reverse
    {:reply, recent, state}
  end

  @impl true
  def handle_call({:push_message, message}, _, state) do
    tail =
      state
      |> Enum.take(@fetch_messages_length-1)
    {:reply, message, [message | tail]}
  end
end
