defmodule Db do
  def exec(query) do
    conn() |> Xandra.execute(query)
  end

  # Connects to the cluster and selects the keyspace based
  # on the environment configuration
  defp conn do
    config = Application.fetch_env!(:connect, :db)
    nodes = Keyword.fetch!(config, :nodes)
    keyspace = Keyword.fetch!(config, :keyspace)

    {:ok, conn} = Xandra.start_link(nodes: nodes, protocol_version: :v4, atom_keys: true)
    conn |> Xandra.execute("CREATE KEYSPACE IF NOT EXISTS #{keyspace} WITH REPLICATION = { 'class': 'SimpleStrategy', 'replication_factor': 1 }")
    conn |> Xandra.execute("USE #{keyspace}")
    conn
  end
end
