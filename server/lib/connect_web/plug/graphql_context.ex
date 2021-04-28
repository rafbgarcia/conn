defmodule ConnectWeb.GraphqlContext do
  @behaviour Plug

  import Plug.Conn
  alias ConnectWeb.Guardian

  def init(opts), do: opts

  def call(conn, _) do
    authorization_header = get_req_header(conn, "authorization")
    context = build_context(Enum.at(authorization_header, 0))
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context("Bearer " <> token) do
    with {:ok, current_user} <- authorize(token) do
      %{current_user: current_user}
    else
      _ -> %{}
    end
  end

  def build_context(_), do: %{}

  defp authorize(token) do
    with {:ok, claims} <- Guardian.decode_and_verify(token) do
      Guardian.resource_from_claims(claims)
    else
      _ -> {:error, "invalid token"}
    end
  end
end
