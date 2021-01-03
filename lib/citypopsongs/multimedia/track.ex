defmodule Citypopsongs.Multimedia.Track do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  schema "tracks" do
    field :artist, :string
    field :slug, :string
    field :title, :string
    field :seconds, :integer

    timestamps()
  end

  @doc false
  def changeset(track, attrs) do
    track
    |> cast(attrs, [:title, :slug, :artist, :seconds])
    |> validate_required([:title, :slug, :artist, :seconds])
    |> unique_constraint([:title])
  end

  def random(query) do
    from track in query,
    order_by: fragment("RANDOM()"),
    limit: 1
  end

  def search(query, search_term) do
    wildcard_search = "%#{search_term}%"
    from track in query,
    where: ilike(track.title, ^wildcard_search)
  end

  def sort(query, sort_by) do
    case sort_by do
      nil ->
        from track in query, order_by: [asc: :title]
      "title" ->
        from track in query, order_by: [asc: :title]
      "artist" ->
        from track in query, order_by: [asc: :artist]
    end
  end
end
