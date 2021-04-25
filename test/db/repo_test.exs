defmodule Db.RepoTest do
  use IntegrationCase, truncate_tables: [:messages]

  alias Db.{Repo, Message, UUID}

  describe ".messages_for_channel" do
    test "returns channel's messages" do
      message = %{channel_id: UUID.uuid(), content: "hey", author_id: 2}
      Repo.insert!(Message.new(message))
      Repo.insert!(Message.new(message))

      messages = Repo.messages_for_channel(message.channel_id)
      assert Kernel.length(messages) == 2
    end
  end
end
