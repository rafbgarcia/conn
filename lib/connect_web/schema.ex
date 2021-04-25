defmodule ConnectWeb.Schema do
  use Absinthe.Schema
  import_types(ConnectWeb.Schema.Types)

  query do
    @desc "Get user's channels"
    field :channels, list_of(:channel) do
      resolve(&ConnectWeb.Resolvers.Channels.list/3)
    end
  end

  mutation do
    field :create_message, :message do
      arg(:channel_id, non_null(:string))
      arg(:content, non_null(:string))

      resolve(&ConnectWeb.Resolvers.Messages.create/3)
    end
  end

  subscription do
    field :new_message, :message do
      arg(:channel_ids, list_of(non_null(:string)))

      config(fn args, _ ->
        {:ok, topic: args.channel_ids}
      end)

      trigger(:create_message,
        topic: fn message ->
          message.channel_id
        end
      )
    end
  end
end
