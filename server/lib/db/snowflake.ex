defmodule Db.Snowflake do
  @bucket_size 30
  def new do
    {:ok, id} = Snowflake.next_id()
    id
  end

  def bucket(id) do
    Snowflake.Util.bucket(@bucket_size, :days, id)
  end

  def bucket_range(start_id, end_id \\ nil) do
    bucket(end_id || new())..bucket(start_id)
  end

  def connect_epoch do
    Snowflake.Helper.epoch()
  end

  def gen_buckets_diff_id(buckets) do
    connect_epoch()
    |> DateTime.from_unix!(:millisecond)
    |> DateTime.add(60 * 60 * 24 * @bucket_size * buckets, :second)
    |> DateTime.to_unix(:millisecond)
    |> Snowflake.Util.first_snowflake_for_timestamp()
  end
end
