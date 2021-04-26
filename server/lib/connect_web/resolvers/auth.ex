defmodule ConnectWeb.Resolvers.Auth do
  alias Db.Account

  def login(_parent, args, _resolution) do
    case Connect.get_account(args.server_id, args.login) do
      nil ->
        {:error, :unauthorized}

      %Account{} = account ->
        with true <- Bcrypt.verify_pass(args.password, account.password),
             {:ok, token, _claims} <- ConnectWeb.Guardian.encode_and_sign(account) do
          {:ok, %{token: token}}
        else
          _ -> {:error, :unauthorized}
        end
    end
  end
end
