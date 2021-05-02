defmodule ConnectWeb.Schema do
  use Absinthe.Schema
  import_types(ConnectWeb.Schema.Types)
  import_types(ConnectWeb.Schema.ScalarTypes)

  query do
    @desc "Get user's channels"
    field :channels, list_of(:channel) do
      resolve(&ConnectWeb.Resolvers.Channels.list/3)
    end

    field :messages, list_of(:message) do
      arg(:channel_id, non_null(:bigint))

      resolve(&ConnectWeb.Resolvers.Messages.list/3)
    end

    field :thread_messages, list_of(:message) do
      arg(:channel_id, non_null(:bigint))
      arg(:parent_message_id, non_null(:bigint))

      resolve(&ConnectWeb.Resolvers.Messages.thread_messages/3)
    end
  end

  mutation do
    field :login, :account do
      arg(:server_id, non_null(:bigint))
      arg(:login, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&ConnectWeb.Resolvers.Auth.login/3)
    end

    field :create_channel, :channel do
      arg(:server_id, non_null(:bigint))
      arg(:name, non_null(:string))
      arg(:type, non_null(:channel_type))

      resolve(&ConnectWeb.Resolvers.Channels.create/3)
    end

    field :create_members, list_of(:member) do
      arg(:channel_id, non_null(:bigint))
      arg(:member_ids, non_null(list_of(:integer)))

      resolve(&ConnectWeb.Resolvers.ChannelMembers.create/3)
    end

    field :create_message, :message do
      arg(:channel_id, non_null(:bigint))
      arg(:parent_message_id, :bigint)
      arg(:content, non_null(:string))

      resolve(&ConnectWeb.Resolvers.Messages.create/3)
    end

    field :edit_message, :message do
      arg(:channel_id, non_null(:bigint))
      arg(:message_id, non_null(:bigint))
      arg(:content, non_null(:string))

      resolve(&ConnectWeb.Resolvers.Messages.edit/3)
    end
  end

  subscription do
    field :new_message, :new_message do
      arg(:channel_ids, list_of(non_null(:string)))

      config(fn args, _ ->
        {:ok, topic: args.channel_ids}
      end)

      trigger(:create_message, topic: & &1.channel_id)

      resolve(fn message, _topics, _resolutions ->
        {:ok, %{message: message}}
      end)
    end
  end
end
