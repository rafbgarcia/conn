defmodule Mix.Tasks.Connect.CreateSchema do
  use Mix.Task

  @shortdoc "Creates Schema"

  def run(_args) do
    Mix.Task.run("app.start")

    schema()
    |> Enum.each(&Db.Repo.exec/1)
  end

  defp schema do
    keyspace = Db.Repo.keyspace()

    [
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.servers(
        id uuid,
        name text,
        config map<text, text>,
        PRIMARY KEY (id)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.accounts(
        server_id uuid,
        member_id int,
        login text,
        password text,
        created_at timestamp,
        edited_at timestamp,
        PRIMARY KEY(server_id, login)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.members(
        server_id uuid,
        id uuid,
        name text,
        avatar text,
        active boolean,
        metadata map<text, text>,
        created_at timestamp,
        edited_at timestamp,
        PRIMARY KEY(server_id, id)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.channels(
        server_id uuid,
        deleted boolean,
        id timeuuid,
        name text,
        direct boolean,
        public boolean,
        broadcast boolean,
        admin_ids set<int>,
        broadcaster_ids set<int>,
        created_at timestamp,
        edited_at timestamp,
        PRIMARY KEY((server_id, deleted), id)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.channel_members(
        server_id uuid,
        channel_id timeuuid,
        member_id uuid,
        joined_at timestamp,
        created_at timestamp,
        edited_at timestamp,
        PRIMARY KEY(channel_id, joined_at, member_id)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.messages(
        channel_id uuid,
        bucket text,
        id timeuuid,
        author_id int,
        content text,
        mentions_all boolean,
        mentions set<int>,
        mention_roles set<int>,
        attachments list<frozen<map<text, text>>>,
        created_at timestamp,
        edited_at timestamp,
        PRIMARY KEY((channel_id, bucket), id)
      ) WITH CLUSTERING ORDER BY (id DESC);
      """,
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.bookmarks(
        member_id int,
        channel_id uuid,
        last_message_at timestamp,
        PRIMARY KEY(member_id, last_message_at, channel_id)
      );
      """
      # """
      # CREATE TABLE IF NOT EXISTS #{keyspace}.events(
      #   server_id uuid,
      #   id uuid,
      #   position int,
      #   image text,
      #   PRIMARY KEY(server_id, position)
      # );
      # """,
      # """
      # CREATE TABLE IF NOT EXISTS #{keyspace}.event_sections(
      #   event_id int,
      #   id uuid,
      #   name text,
      #   position int,
      #   PRIMARY KEY(event_id, position)
      # );
      # """,
      # """
      # CREATE TABLE IF NOT EXISTS #{keyspace}.event_items(
      #   event_id int,
      #   section_id int,
      #   name text,
      #   position int,
      #   type text,
      #   url text,
      #   channel_id uuid,
      #   PRIMARY KEY(event_id, position)
      # );
      # """
    ]
  end
end
