# defmodule ConnectWeb.AuthTest do
#   use ConnectWeb.ConnCase

#   import ConnectWeb.Guardian

#   test "login", %{conn: conn} do
#     user = insert(:user)

#     {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)

#     conn =
#       conn
#       |> put_req_header("authorization", "Bearer " <> token)
#       |> get(auth_path(conn, :me))

#     # Assert things here
#   end
# end
