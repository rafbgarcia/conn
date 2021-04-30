defmodule Connect.SnowflakeTest do
  use ExUnit.Case

  test "generates a sortable unique ID even on high concurrency" do
    ids = Enum.map(0..10000, &[Db.Snowflake.new(), &1])
    assert ids == Enum.sort_by(ids, &Enum.at(&1, 0))
  end

  test "generates bucket related to Connect's epoch" do
    id = Db.Snowflake.gen_buckets_diff_id(0)
    assert Db.Snowflake.bucket(id) == 0

    id = Db.Snowflake.gen_buckets_diff_id(1)
    assert Db.Snowflake.bucket(id) == 1

    id = Db.Snowflake.gen_buckets_diff_id(14)
    assert Db.Snowflake.bucket(id) == 14
  end

  test "generates bucket_range" do
    id = Db.Snowflake.gen_buckets_diff_id(1)
    now = Db.Snowflake.gen_buckets_diff_id(5)
    assert Db.Snowflake.bucket_range(id, now) == 5..1
  end
end
