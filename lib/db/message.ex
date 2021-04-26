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
  end

  def new(attrs) do
    data =
      attrs
      |> Map.merge(%{
        id: UUID.timeuuid(),
        bucket: bucket(Date.utc_today())
      })

    cast(%Message{}, data, [
      :channel_id,
      :bucket,
      :id,
      :content,
      :author_id
    ])
  end

  # Messages partitions are split by (channel, bucket)
  # not to increase the partition size indefinitely.
  defp bucket(date) do
    semester =
      case date.month do
        n when n <= 6 -> 1
        _ -> 2
      end

    "#{date.year}#{semester}"
  end
end
