defmodule ConnectWeb.MessagesTest do
  alias Db.{Repo, Server, Channel}

  use ConnectWeb.ConnCase
  use IntegrationCase, truncate_tables: [:servers, :channels, :messages]

  test "createMessage", %{conn: conn} do
    server = Repo.insert!(Server.new(%{name: "Power"}))
    channel = Repo.insert!(Channel.new(%{server_id: server.id, name: "Rebels"}))

    query = """
    mutation {
      createMessage(channelId: "#{channel.id}", content: "Hello world") {
        id
        channelId
        authorId
        content
      }
    }
    """

    conn = post(conn, "/api", query: query)

    assert %{
             "data" => %{
               "createMessage" => %{
                 "authorId" => "123",
                 "channelId" => _,
                 "content" => "Hello world",
                 "id" => _
               }
             }
           } = json_response(conn, 200)
  end
end
