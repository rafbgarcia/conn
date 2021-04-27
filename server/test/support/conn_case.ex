defmodule ConnectWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use ConnectWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import ConnectWeb.ConnCase
      import Connect.Factory
      alias ConnectWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint ConnectWeb.Endpoint

      @doc """
      Makes an authenticated Graphql request
      """
      def gql(query) do
        {token, user, account} = jwt()

        conn =
          build_conn()
          |> put_req_header("authorization", "Bearer #{token}")
          |> post("/api", query: query)

        %{res: json_response(conn, 200), token: token, user: user, account: account}
      end

      @doc """
      Makes an authenticated Graphql request using the given token
      """
      def gql_with_token(query, token) do
        build_conn()
        |> put_req_header("authorization", "Bearer #{token}")
        |> post("/api", query: query)
        |> json_response(200)
      end

      @doc """
      Makes an unauthenticated Graphql request
      """
      def non_auth_gql(query) do
        build_conn()
        |> post("/api", query: query)
        |> json_response(200)
      end
    end
  end

  setup _tags do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
