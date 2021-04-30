defmodule Connect.Factory do
  def build(name, attrs \\ %{}) do
    apply(__MODULE__, name, [attrs |> Enum.into(%{})])
  end

  def insert(name_or_struct, attrs \\ %{}) do
    case name_or_struct do
      name when is_atom(name) ->
        Db.Repo.insert!(build(name, attrs))

      struct when is_struct(struct) ->
        Db.Repo.insert!(struct)

      _ ->
        raise "Invalid factory name"
    end
  end

  # Factories

  def user(attrs \\ %{}) do
    attrs
    |> Map.put(:id, attrs[:id] || sequence(:user_id))
    |> Map.put(:server_id, attrs[:server_id] || Db.Snowflake.new())
    |> Map.put(:name, attrs[:name] || sequence(:name, &"User #{&1}"))
    |> to_struct(Db.User)
  end

  def channel(attrs \\ %{}) do
    attrs
    |> Map.put(:server_id, attrs[:server_id] || Db.Snowflake.new())
    |> Map.put(:name, attrs[:name] || Db.Snowflake.new())
    |> to_struct(Db.Channel)
  end

  def message(attrs \\ %{}) do
    attrs
    |> Map.put(:channel_id, attrs[:channel_id] || Db.Snowflake.new())
    |> Map.put(:author_id, attrs[:author_id] || sequence(:user_id))
    |> to_struct(Db.Message)
  end

  def thread_message(attrs \\ %{}) do
    attrs
    |> Map.put(:channel_id, attrs[:channel_id] || Db.Snowflake.new())
    |> Map.put(:parent_message_id, attrs[:parent_message_id] || Db.Snowflake.new())
    |> Map.put(:author_id, attrs[:author_id] || sequence(:user_id))
    |> to_struct(Db.ThreadMessage)
  end

  def account(attrs \\ %{}) do
    attrs
    |> Map.put(:server_id, attrs[:server_id] || Db.Snowflake.new())
    |> Map.put(:user_id, attrs[:user_id] || sequence(:user_id))
    |> Map.put(:login, attrs[:login] || sequence(:login, &"login #{&1}"))
    |> Map.put(:password, attrs[:password] || sequence(:password, &"pass-#{&1}"))
    |> to_struct(Db.Account)
  end

  # JSON Web Token
  def jwt(user \\ nil) do
    user = user || insert(:user)
    account = insert(:account, user_id: user.id, server_id: user.server_id)
    {:ok, jwt, _claims} = ConnectWeb.Guardian.encode_and_sign(account)

    {jwt, user, account}
  end

  # Private

  defp to_struct(attrs, schema) do
    struct(schema, schema.new(attrs).changes)
  end

  defp sequence(name, fun \\ & &1) do
    Connect.FactorySequence.get(name)
    |> case do
      nil ->
        Connect.FactorySequence.put(name, 1)
        fun.(0)

      val ->
        Connect.FactorySequence.put(name, val + 1)
        fun.(val)
    end
  end
end
