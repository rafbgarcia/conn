defmodule Mix.Tasks.Connect.CreateSchema do
  use Mix.Task

  @shortdoc "Creates Schema"

  def run(_args) do
    Mix.Task.run("app.start")

    schema()
    |> Enum.each(&Db.Repo.cql/1)
  end

  defp schema do
    keyspace = Db.Repo.__keyspace__()

    [
      # `user_metadata` will be used to fetch additional fields
      # from the GraphQL endpoint in Nitro, and also to select
      # users by these fields (as with Audiences)
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.servers(
        id uuid,
        name text,
        config map<text, text>,
        user_metadata map<text, text>,
        PRIMARY KEY (id)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.accounts(
        server_id uuid,
        login text,
        user_id int,
        password text,
        created_at timestamp,
        edited_at timestamp,
        PRIMARY KEY(server_id, login)
      );
      """,
      """
      CREATE TABLE IF NOT EXISTS #{keyspace}.users(
        server_id uuid,
        id int,
        handle text,
        name text,
        avatar text,
        active boolean,
        created_at timestamp,
        edited_at timestamp,
        metadata map<text, text>,
        PRIMARY KEY(server_id, id, handle)
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
      CREATE TABLE IF NOT EXISTS #{keyspace}.channel_users(
        server_id uuid,
        channel_id timeuuid,
        user_id uuid,
        joined_at timestamp,
        created_at timestamp,
        edited_at timestamp,
        PRIMARY KEY(channel_id, joined_at, user_id)
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
        user_id int,
        channel_id uuid,
        last_message_at timestamp,
        PRIMARY KEY(user_id, last_message_at, channel_id)
      );
      """
      # """
      # CREATE TABLE IF NOT EXISTS #{keyspace}.notification_preferences(
      #   channel_id uuid,
      #   user_id int,
      #   level int,
      #   PRIMARY KEY(channel_id)
      # );
      # """,
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
