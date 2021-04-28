defmodule Db.Message do
  use Cassandrax.Schema
  import Ecto.Changeset

  alias Db.{UUID, Message}

  @primary_key [[:channel_id, :bucket], :id]

  table "messages" do
    field(:channel_id, :string)
    field(:bucket, :string)
    field(:id, :string)
    field(:content, :string)
    field(:author_id, :integer)
    field(:created_at, :utc_datetime)
    field(:edited_at, :utc_datetime)
  end

  def new(attrs) do
    attrs =
      attrs
      |> Map.put(:id, UUID.timeuuid())
      |> Map.put(:bucket, bucket(Date.utc_today()))
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

  # Messages partitions are split by (channel, bucket)
  # not to increase the partition size indefinitely.
  def bucket(date) do
    semester =
      case date.month do
        n when n <= 6 -> 1
        _ -> 2
      end

    "#{date.year}#{semester}"
  end
end
