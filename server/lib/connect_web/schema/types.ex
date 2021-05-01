defmodule ConnectWeb.Schema.Types do
  use Absinthe.Schema.Notation

  object :account do
    field(:token, :string)
  end

  object :channel do
    field(:server_id, :bigint)
    field(:id, :bigint)
    field(:name, :string)
    field(:owner_id, :integer)
    field(:type, :integer)
  end

  object :member do
    field(:channel_id, non_null(:bigint))
    field(:user_id, non_null(:integer))
    field(:admin, non_null(:boolean))
    field(:broadcaster, non_null(:boolean))
  end

  object :message do
    field(:id, non_null(:bigint))
    field(:channel_id, non_null(:bigint))
    field(:author_id, non_null(:integer))
    field(:content, non_null(:string))
    field(:created_at, non_null(:string))

    field(:edited, non_null(:boolean)) do
      resolve(fn message, _, _ ->
        {:ok, is_struct(message.edited_at)}
      end)
    end

    field(:parent_message_id, :bigint)
    field(:edited_at, :string)
  end

  object :badge do
    field(:channel_id, :bigint)
    field(:count, :integer)
    field(:mentions_me, :boolean)
    field(:mentions_all, :boolean)
  end

  object :new_message do
    field(:message, :message)
    field(:bookmark, :string)
    field(:notification, :string)

    field(:badges, :badge) do
      resolve(fn parent, args, resolutions ->
        async(fn ->
          ConnectWeb.Resolvers.Badges.update(parent, args, resolutions)
        end)
      end)
    end
  end
end
