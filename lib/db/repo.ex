defmodule Db.Repo do
  @keyspace Application.fetch_env!(:connect, :db) |> Keyword.fetch!(:keyspace)

  use Cassandrax.Keyspace, cluster: Connect.Cluster, name: @keyspace

  import Cassandrax.Query

  alias Db.Message

  @spec messages_for_channel(String.t()) :: list(Db.Message)
  def messages_for_channel(channel_id) do
    Message
    |> where(:channel_id == channel_id)
    |> limit(50)
    |> allow_filtering
    |> all
  end

  def exec(statement) do
    cql(statement)
  end

  def table_names do
    {:ok, result} =
      exec("SELECT table_name FROM system_schema.tables WHERE keyspace_name = '#{@keyspace}'")

    Enum.map(result, & &1.table_name)
  end

  def keyspace, do: @keyspace
end
