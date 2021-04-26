defmodule Subject do
  @key "__SPLIT__"

  def encode(%{server_id: server_id, user_id: user_id}), do: Enum.join([server_id, user_id], @key)

  def decode(subject), do: String.split(subject, @key)
end

defmodule ConnectWeb.Guardian do
  use Guardian, otp_app: :connect

  def subject_for_token(account, _claims) do
    subject = Subject.encode(account)
    {:ok, subject}
  end

  def resource_from_claims(claims) do
    subject = claims["sub"]
    [server_id, user_id] = Subject.decode(subject)

    Db.Api.get_user(server_id, String.to_integer(user_id))
    |> case do
      nil -> {:error, "Invalid token"}
      user -> {:ok, user}
    end
  end
end
