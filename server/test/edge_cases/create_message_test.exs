defmodule Connect.EdgeCases.CreateMessageTest do
  use ConnectWeb.ConnCase

  test "fails when for unauthorized users" do
    query = """
    mutation {
      message: createMessage(channelId: "#{Db.Snowflake.new()}", content: "Hello world") {
        id
      }
    }
    """

    res = gql_with_token(query, "invalid")

    assert Enum.at(res["errors"], 0)["message"] == "unauthorized"
  end
end
