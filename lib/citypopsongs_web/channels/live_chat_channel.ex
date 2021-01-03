defmodule CitypopsongsWeb.LiveChatChannel do
  use CitypopsongsWeb, :channel
  alias Citypopsongs.Multimedia

  @impl true
  def join("live_chat:lobby", _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end
end
