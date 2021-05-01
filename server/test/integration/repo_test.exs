defmodule Connect.RepoTest do
  use ConnectWeb.ConnCase, async: true
  use Connect.IntegrationCase, truncate_tables: [:channels, :messages]
  import Cassandrax.Query

  test ".to_sql" do
    sql = Db.Message |> where(channel_id: 1) |> limit(2) |> Db.Repo.to_sql()

    assert sql ==
             {"SELECT * FROM \"connect_test\".\"messages\" WHERE (\"channel_id\" = ?) LIMIT ?",
              [1, 2]}
  end

  test ".table_names" do
    tables = Db.Repo.table_names()

    assert Enum.member?(tables, Db.Account.__schema__(:queryable).from)
    assert Enum.member?(tables, Db.Message.__schema__(:queryable).from)
    assert Enum.member?(tables, Db.Server.__schema__(:queryable).from)
  end
end
