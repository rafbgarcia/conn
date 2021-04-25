defmodule Db.Base do
  def insert(table_name, schema, params) do
    placeholders = Enum.map(schema, fn {field, _} -> ":#{field}" end) |> Enum.join(",")
    fields = Map.keys(schema) |> Enum.join(",")

    values =
      Map.keys(schema)
      |> Enum.reduce(%{}, fn field, acc ->
        Map.put(acc, field, {schema[field], params[field]})
      end)

    exec("INSERT INTO #{table_name} (#{fields}) VALUES (#{placeholders})", values)
  end

  def exec(statement, params \\ []) do
    Xandra.execute!(conn(), statement, params, page_size: 1_000)
  end

  def config(key) do
    Application.fetch_env!(:connect, :db)
    |> Keyword.fetch!(key)
  end

  def table_names do
    exec("SELECT table_name FROM system_schema.tables WHERE keyspace_name = 'connect_test'")
    |> Enum.map(& &1.table_name)
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
end
