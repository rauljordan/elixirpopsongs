defmodule CitypopsongsWeb.RadioController do
  use CitypopsongsWeb, :controller
  alias Citypopsongs.Chats.LiveChat

  def index(conn, params) do
    messages = LiveChat.get_recent_messages()
    render(conn, "index.html", messages: messages)
  end
end
