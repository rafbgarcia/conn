defmodule Mix.Tasks.Connect.RecreateSchema do
  use Mix.Task

  @shortdoc "Recreates Schema (easier for development)"

  def run(_args) do
    Mix.Task.run("app.start")

    tables()
    |> Enum.each(fn table ->
      case Db.exec(table) do
        {:ok, _} ->
          nil

        {:error, error} ->
          Mix.shell().info(">>> An error occured:\n#{error.reason}: #{error.message}\n#{table}")
      end
    end)
  end

  defp tables do
    [
      "DROP TABLE IF EXISTS servers",
      "DROP TABLE IF EXISTS accounts",
      "DROP TABLE IF EXISTS members",
      "DROP TABLE IF EXISTS channels",
      "DROP TABLE IF EXISTS channel_members",
      "DROP TABLE IF EXISTS messages",
      "DROP TABLE IF EXISTS bookmarks",
      "DROP TABLE IF EXISTS events",
      "DROP TABLE IF EXISTS event_sections",
      "DROP TABLE IF EXISTS event_items"
    ]
  end
end
