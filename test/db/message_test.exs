defmodule Db.MessageTest do
  use ExUnit.Case
  use IntegrationCase, truncate_tables: [:messages]

  alias Db.{Message, UUID}

  describe "new" do
    test "returns the message" do
      attrs = %{channel_id: UUID.uuid(), content: "hey", author_id: 2}
      message = Message.new(attrs).changes

      assert is_binary(message.id)
      assert is_binary(message.bucket)
      assert message.channel_id == attrs.channel_id
      assert message.author_id == attrs.author_id
      assert message.content == attrs.content
    end
  end
end
