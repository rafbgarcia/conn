defmodule ConnectWeb.Schema.Types do
  use Absinthe.Schema.Notation

  object :channel do
    field(:id, :id)
    field(:name, :string)
  end

  object :message do
    field(:id, :id)
    field(:channel_id, :string)
    field(:content, :string)
  end
end
