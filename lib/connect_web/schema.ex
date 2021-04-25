defmodule ConnectWeb.Schema do
  use Absinthe.Schema
  import_types(ConnectWeb.Schema.Types)

  query do
    @desc "Get user's channels"
    field :channels, list_of(:channel) do
      resolve(&ConnectWeb.Resolvers.Channels.list/3)
    end
  end
end
