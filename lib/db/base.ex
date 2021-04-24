defmodule Db.Base do
  def exec(statement, params \\ []) do
    Xandra.execute!(conn(), statement, params, page_size: 1_000)
  end

  # Connects to the cluster and uses environment's keyspace
  defp conn do
    {:ok, conn} =
      Xandra.start_link(
        nodes: config(:nodes),
        # Scylla does no support v4
        protocol_version: :v3,
        atom_keys: true
      )

    use_keyspace(conn)
    conn
  end

  defp use_keyspace(conn) do
    keyspace = config(:keyspace)

    Xandra.execute(
      conn,
      """
        CREATE KEYSPACE IF NOT EXISTS #{keyspace}
        WITH REPLICATION = { 'class': 'SimpleStrategy', 'replication_factor': 1 }
      """
    )

    Xandra.execute(conn, "USE #{keyspace}")
  end

  defp config(key) do
    Application.fetch_env!(:connect, :db)
    |> Keyword.fetch!(key)
  end
end
