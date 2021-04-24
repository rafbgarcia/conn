defmodule Db.Messages do
  def create(%{channel_id: channel_id, content: content}) do
    id = Db.UUID.timeuuid()

    Db.Base.exec(
      """
      INSERT INTO messages (channel_id, bucket, id, content)
      VALUES(:channel_id, :bucket, :id, :content)
      """,
      %{
        channel_id: {"uuid", channel_id},
        bucket: {"text", bucket(Date.utc_today())},
        id: {"timeuuid", id},
        content: {"text", content}
      }
    )

    id
  end

  # The `bucket` splits channel messages by month not to
  # increase the partition size indefinitely.
  def bucket(date) do
    "#{date.year}#{date.month}"
  end
end
