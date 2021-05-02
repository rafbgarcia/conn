defmodule Connect.GraphqlContextTest do
  use ConnectWeb.ConnCase, async: true

  test "puts current_user in Absinthe's context" do
    {token, user, _} = jwt()

    conn =
      build_conn()
      |> put_req_header("authorization", "Bearer #{token}")
      |> ConnectWeb.GraphqlContext.call([])

    assert conn.private.absinthe.context.current_user == user
  end

  test "returns user for a given token" do
    {token, user, _} = jwt()
    authorization_header = "Bearer #{token}"

    assert %{current_user: user} == ConnectWeb.GraphqlContext.build_context(authorization_header)
  end

  test "returns empty if no token is given" do
    assert %{} == ConnectWeb.GraphqlContext.build_context("")
  end

  test "init" do
    assert [opt: 1] == ConnectWeb.GraphqlContext.init(opt: 1)
  end
end
