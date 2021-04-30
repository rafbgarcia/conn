defmodule ConnectWeb.Guardian do
  use Guardian, otp_app: :connect

  def subject_for_token(account, _claims) do
    subject = encode(account)
    {:ok, subject}
  end

  def resource_from_claims(claims) do
    subject = claims["sub"]
    [server_id, user_id] = decode(subject)

    Connect.get_user(server_id, user_id)
    |> case do
      nil -> {:error, "Invalid token"}
      user -> {:ok, user}
    end
  end

  @key "__SPLIT__"

  defp encode(%{server_id: server_id, user_id: user_id}),
    do: Enum.join([server_id, user_id], @key)

  defp decode(subject), do: String.split(subject, @key) |> Enum.map(&String.to_integer/1)
end
