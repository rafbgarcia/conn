defmodule Db.Message do
  use Cassandrax.Schema
  import Ecto.Changeset

  alias Db.{Message}

  @primary_key [[:channel_id, :bucket], :id]

  table "messages" do
    field(:channel_id, :integer)
    field(:bucket, :integer)
    field(:id, :integer)
    field(:content, :string)
    field(:author_id, :integer)
    field(:created_at, :utc_datetime)
    field(:edited_at, :utc_datetime)
  end

  def new(attrs) do
    id = Db.Snowflake.new()

    attrs =
      attrs
      |> Map.put(:id, id)
      |> Map.put(:bucket, attrs[:bucket] || Db.Snowflake.bucket(id))
      |> Map.put(:created_at, DateTime.utc_now())

    cast(%Message{}, attrs, [
      :channel_id,
      :bucket,
      :id,
      :content,
      :author_id,
      :created_at
    ])
    |> validate_required([:channel_id, :bucket, :id, :author_id, :created_at])
  end

  def edit(message, attrs) do
    message
    |> change(content: attrs.content)
    |> change(edited_at: DateTime.truncate(DateTime.utc_now(), :second))
  end
end
