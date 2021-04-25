defmodule Db.MessagesTest do
  use ExUnit.Case
  use ConnectTest.IntegrationCase, truncate_tables: [:messages]

  alias Db.Messages

  test "persists a message in the database" do
    params = %{channel_id: Db.UUID.uuid(), content: "hey", author_id: 2}
    Messages.create(params)
    Messages.create(params)

    messages = Messages.for_channel(params.channel_id)
    assert Kernel.length(messages) == 2
  end

  test "returns the message" do
    params = %{channel_id: Db.UUID.uuid(), content: "hey", author_id: 2}
    message = Messages.create(params)

    assert is_binary(message.id)
    assert is_binary(message.bucket)
    assert message.content == params.content
    assert message.channel_id == params.channel_id
    assert message.author_id == params.author_id
  end
end
