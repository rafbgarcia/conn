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
end
