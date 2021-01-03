defmodule CitypopsongsWeb.LiveChatChannel do
  use CitypopsongsWeb, :channel
  alias Citypopsongs.Chats.LiveChat
  alias Citypopsongs.Chats.Chat

  @impl true
  def join("live_chat:lobby", _payload, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_in("shout", payload, socket) do
    message = %Chat{
      name: Map.get(payload, "name"),
      body: Map.get(payload, "body")
    }
    LiveChat.push_message(message)
    broadcast socket, "shout", payload
    {:noreply, socket}
  end
end
