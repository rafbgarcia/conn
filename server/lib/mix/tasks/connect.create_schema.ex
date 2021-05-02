defmodule Mix.Tasks.Connect.CreateSchema do
  use Mix.Task

  @shortdoc "Creates Schema"

  def run(_args) do
    Mix.Task.run("app.start")
    ensure_keyspace()

    schema()
    |> Enum.each(&({:ok, _} = Db.Repo.cql(&1)))
  end

  defp ensure_keyspace do
    {:ok, _} =
      Db.Repo.cql("""
      CREATE KEYSPACE IF NOT EXISTS #{Db.Repo.__keyspace__()}
      WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 1}
      """)
  end

  defp schema do
    keyspace = Db.Repo.__keyspace__()

    [
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.servers(
        id bigint,
        name text,
        config map<text, text>,
        user_metadata map<text, text>,
        PRIMARY KEY (id)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.accounts(
        server_id bigint,
        login text,
        user_id bigint,
        password text,
        created_at timestamp,
        edited_at timestamp,
        PRIMARY KEY(server_id, login)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.users(
        server_id bigint,
        id bigint,
        handle text,
        name text,
        avatar text,
        active boolean,
        created_at timestamp,
        edited_at timestamp,
        metadata map<text, text>,
        PRIMARY KEY(server_id, id)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.channels(
        server_id bigint,
        owner_id bigint,
        id bigint,
        name text,
        topic text,
        type text,
        created_at timestamp,
        edited_at timestamp,
        PRIMARY KEY(server_id, id)
      ) WITH CLUSTERING ORDER BY (id DESC);
      """,
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.channel_members(
        channel_id bigint,
        user_id bigint,
        admin boolean,
        broadcaster boolean,
        PRIMARY KEY(channel_id, user_id)
      );
      """,
      """
      CREATE INDEX member_channels ON #{keyspace}.channel_members(user_id);
      """,
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.messages(
        channel_id bigint,
        bucket int,
        id bigint,
        author_id bigint,
        content text,
        mentions_all boolean,
        mentions set<bigint>,
        mention_roles set<int>,
        attachments list<frozen<map<text, text>>>,
        created_at timestamp,
        edited_at timestamp,
        PRIMARY KEY((channel_id, bucket), id)
      ) WITH CLUSTERING ORDER BY (id DESC);
      """,
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.thread_messages(
        parent_message_id bigint,
        id bigint,
        channel_id bigint,
        author_id bigint,
        content text,
        mentions_all boolean,
        mentions set<int>,
        mention_roles set<int>,
        attachments list<frozen<map<text, text>>>,
        created_at timestamp,
        edited_at timestamp,
        PRIMARY KEY(parent_message_id, id)
      ) WITH CLUSTERING ORDER BY (id DESC);
      """,
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.bookmarks(
        user_id bigint,
        channel_id bigint,
        last_message_at timestamp,
        PRIMARY KEY(user_id, last_message_at, channel_id)
      );
      """
      # """
      # CREATE TABLE IF NOT EXISTS #{keyspace}.notification_preferences(
      #   channel_id bigint,
      #   user_id bigint,
      #   level int,
      #   PRIMARY KEY(channel_id)
      # );
      # """,
      # """
      # CREATE TABLE IF NOT EXISTS #{keyspace}.events(
      #   server_id bigint,
      #   id bigint,
      #   position int,
      #   image text,
      #   PRIMARY KEY(server_id, position)
      # );
      # """,
      # """
      # CREATE TABLE IF NOT EXISTS #{keyspace}.event_sections(
      #   event_id bigint,
      #   id bigint,
      #   name text,
      #   position int,
      #   PRIMARY KEY(event_id, position)
      # );
      # """,
      # """
      # CREATE TABLE IF NOT EXISTS #{keyspace}.event_items(
      #   event_id bigint,
      #   section_id bigint,
      #   name text,
      #   position int,
      #   type text,
      #   url text,
      #   channel_id bigint,
      #   PRIMARY KEY(event_id, position)
      # );
      # """
    ]
  end
end
