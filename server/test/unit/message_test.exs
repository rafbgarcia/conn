defmodule Connect.Unit.MessageTest do
  use ExUnit.Case

  alias Db.{Message}

  describe "new" do
    test "returns the message" do
      attrs = %{channel_id: Db.Snowflake.new(), content: "hey", author_id: 2}
      message = Message.new(attrs).changes

      assert is_integer(message.id)
      assert is_integer(message.bucket)
      assert message.channel_id == attrs.channel_id
      assert message.author_id == attrs.author_id
      assert message.content == attrs.content
      assert is_struct(message.created_at)
    end
  end
end
