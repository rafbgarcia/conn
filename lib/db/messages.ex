defmodule Db.Messages do
  alias Db.Base

  @table_name "messages"
  @schema %{
    channel_id: "uuid",
    bucket: "text",
    id: "timeuuid",
    content: "text",
    author_id: "int"
  }

  def for_channel(channel_id) do
    Base.exec(
      "SELECT id, channel_id, author_id, content FROM messages WHERE channel_id = ? LIMIT 50 ALLOW FILTERING",
      [{"uuid", channel_id}]
    )
    |> Enum.to_list()
  end

  def create(params) do
    message =
      Map.merge(params, %{
        id: Db.UUID.timeuuid(),
        bucket: bucket(Date.utc_today())
      })

    Base.insert(@table_name, @schema, message)

    message
  end

  # Messages partitions are split by (channel, month)
  # not to increase the partition size indefinitely.
  defp bucket(date) do
    "#{date.year}#{date.month}"
  end
end
