defmodule Db.Repo do
  use Cassandrax.Keyspace,
    cluster: Connect.Cluster,
    name: Application.fetch_env!(:connect, :db) |> Keyword.fetch!(:keyspace)

  def table_names do
    {:ok, result} =
      cql("SELECT table_name FROM system_schema.tables WHERE keyspace_name = '#{__keyspace__()}'")

    Enum.map(result, & &1["table_name"])
  end
end
