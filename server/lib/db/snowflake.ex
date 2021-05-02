defmodule Db.Snowflake do
  @bucket_size 30
  def new do
    {:ok, id} = Snowflake.next_id()
    id
  end

  def bucket(id) do
    cond do
      is_integer(id) -> Snowflake.Util.bucket(@bucket_size, :days, id)
      true -> raise "ID must be an integer"
    end
  end

  def bucket_range(start_id, end_id \\ nil) do
    a = bucket(end_id || new())
    b = bucket(start_id)

    cond do
      a > b -> a..b
      true -> b..a
    end
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
