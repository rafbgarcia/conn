defmodule Mix.Tasks.Connect.RecreateSchema do
  use Mix.Task

  @shortdoc "Recreates Schema (easier for development)"

  def run(_args) do
    Mix.Task.run("app.start")

    Enum.each(tables(), &Db.Base.exec/1)

    Mix.Task.run("connect.create_schema")
  end

  defp tables do
    Enum.map(Db.Base.table_names(), &"DROP TABLE IF EXISTS #{&1}")
  end
end
