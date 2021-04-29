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
    field(:parent_message_id, :string)
    field(:author_id, :integer)
    field(:content, :string)
    field(:created_at, :string)

    field(:edited, :boolean) do
      resolve(fn message, _, _ ->
        {:ok, is_struct(message.edited_at)}
      end)
    end

    field(:edited_at, :string)

    field(:messages, list_of(:message)) do
      resolve(&ConnectWeb.Resolvers.Messages.thread_messages/3)
    end
  end

  object :badge do
    field(:channel_id, :string)
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
