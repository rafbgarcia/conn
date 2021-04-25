defmodule Mix.Tasks.Connect.RecreateSchema do
  use Mix.Task

  @shortdoc "Recreates Schema (easier for development)"

  def run(_args) do
    Mix.Task.run("app.start")

    Enum.each(drop_tables(), &Db.Repo.exec/1)

    Mix.Task.run("connect.create_schema")
  end

  defp drop_tables do
    Enum.map(Db.Repo.table_names(), &"DROP TABLE IF EXISTS #{&1}")
  end
end
