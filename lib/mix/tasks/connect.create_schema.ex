defmodule Mix.Tasks.Connect.CreateSchema do
  use Mix.Task

  @shortdoc "Creates Schema"

  def run(_args) do
    Mix.Task.run("app.start")

    schema()
    |> Enum.each(fn table ->
      case Db.exec(table) do
        {:ok, _} -> nil
        {:error, error} ->
          Mix.shell().info(">>> An error occured:\n#{error.reason}: #{error.message}\n#{table}")
      end
    end)
    Mix.shell().info("Success")
  end

  defp schema do
    [
      """
      CREATE TABLE IF NOT EXISTS servers(
        id int,
        name text,
        config map<text, text>,
        PRIMARY KEY (id)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS accounts(
        server_id int,
        member_id int,
        login text,
        password text,
        createdAt timestamp,
        editedAt timestamp,
        PRIMARY KEY(server_id, login)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS members(
        server_id int,
        id int,
        name text,
        avatar text,
        active boolean,
        metadata map<text, text>,
        createdAt timestamp,
        editedAt timestamp,
        PRIMARY KEY(server_id, id)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS channels(
        server_id int,
        id int,
        name text,
        direct boolean,
        public boolean,
        broadcast boolean,
        admin_ids set<int>,
        broadcaster_ids set<int>,
        createdAt timestamp,
        editedAt timestamp,
        PRIMARY KEY(server_id, id)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS channel_members(
        server_id int,
        channel_id int,
        member_id int,
        joined_at timestamp,
        createdAt timestamp,
        editedAt timestamp,
        PRIMARY KEY((server_id, channel_id), joined_at, member_id)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS messages(
        server_id int,
        channel_id int,
        date_range text,
        author_id int,
        id int,
        content text,
        mentions_all boolean,
        mentions set<int>,
        mention_roles set<int>,
        attachments list<frozen<map<text, text>>>,
        createdAt timestamp,
        editedAt timestamp,
        PRIMARY KEY((server_id, channel_id, date_range), id)
      ) WITH CLUSTERING ORDER BY (id DESC);
      """,
      """
      CREATE TABLE IF NOT EXISTS bookmarks(
        server_id int,
        member_id int,
        channel_id int,
        last_message_at timestamp,
        PRIMARY KEY((server_id, member_id), last_message_at, channel_id)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS events(
        server_id int,
        id int,
        position int,
        image text,
        PRIMARY KEY(server_id, position)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS event_sections(
        event_id int,
        id int,
        name text,
        position int,
        PRIMARY KEY(event_id, position)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS event_items(
        event_id int,
        section_id int,
        name text,
        position int,
        type text,
        url text,
        channel_id int,
        PRIMARY KEY(event_id, position)
      );
      """,
    ]
  end
end
