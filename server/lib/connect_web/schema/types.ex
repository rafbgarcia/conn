defmodule ConnectWeb.Schema.Types do
  use Absinthe.Schema.Notation

  object :account do
    field(:token, non_null(:string))
  end

  enum :channel_type do
    value(:broadcasting, as: "BROADCASTING")
    value(:direct, as: "DIRECT")
    value(:group, as: "GROUP")
    value(:private, as: "PRIVATE")
    value(:public, as: "PUBLIC")
  end

  object :channel do
    field(:server_id, non_null(:bigint))
    field(:id, non_null(:bigint))
    field(:name, non_null(:string))
    field(:owner_id, non_null(:integer))
    field(:type, non_null(:channel_type))
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
    field(:channel_id, non_null(:bigint))
    field(:count, non_null(:integer))
    field(:mentions_me, non_null(:boolean))
    field(:mentions_all, non_null(:boolean))
  end

  object :new_message do
    field(:message, non_null(:message))
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
