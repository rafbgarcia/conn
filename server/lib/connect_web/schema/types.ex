defmodule ConnectWeb.Schema.Types do
  use Absinthe.Schema.Notation

  object :account do
    field(:token, :string)
  end

  object :channel do
    field(:id, :id)
    field(:name, :string)
  end

  object :message do
    field(:id, :id)
    field(:channel_id, :string)
    field(:author_id, :integer)
    field(:content, :string)
    field(:created_at, :string)

    field(:edited, :boolean) do
      resolve(fn message, _, _ ->
        {:ok, is_struct(message.edited_at)}
      end)
    end

    field(:edited_at, :string)
  end
end
