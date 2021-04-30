defmodule Connect.SnowflakeTest do
  use ExUnit.Case

  test "generates a sortable unique ID even on high concurrency" do
    ids = Enum.map(0..10000, fn _ -> Db.Snowflake.new() end)
    assert ids == Enum.sort(ids)
  end

  test "generates a bucket relative to Connect's epoch" do
    id = Db.Snowflake.gen_buckets_diff_id(0)
    assert Db.Snowflake.bucket(id) == 0

    id = Db.Snowflake.gen_buckets_diff_id(1)
    assert Db.Snowflake.bucket(id) == 1

    id = Db.Snowflake.gen_buckets_diff_id(14)
    assert Db.Snowflake.bucket(id) == 14
  end

  test "generates bucket_range in descending order" do
    id = Db.Snowflake.gen_buckets_diff_id(1)
    now = Db.Snowflake.gen_buckets_diff_id(5)
    assert Db.Snowflake.bucket_range(id, now) == 5..1
    assert Db.Snowflake.bucket_range(now, id) == 5..1
  end
end
