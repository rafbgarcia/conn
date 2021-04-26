defmodule ConnectWeb.Resolvers.Auth do
  alias Db.{Api, Account}

  def login(_parent, args, _resolution) do
    case Api.get_account(args.server_id, args.login) do
      nil ->
        {:error, :not_found}

      %Account{} = account ->
        # TODO: check pass
        #
        #
        {:ok, token, _claims} = ConnectWeb.Guardian.encode_and_sign(account)
        {:ok, %{token: token}}
    end
  end
end
