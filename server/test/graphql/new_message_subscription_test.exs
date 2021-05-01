defmodule Connect.Graphql.NewMessageSubscriptionTest do
  use ConnectWeb.SubscriptionCase

  def scenario, do: "Real-time channel messages"

  def subscription(channel_id) do
    """
    subscription {
      newMessage(channelIds: ["#{channel_id}"]) {
        message { content }
      }
    }
    """
  end

  def mutation(channel_id, content) do
    """
    mutation {
      createMessage(channelId: "#{channel_id}", content: "#{content}") {
        id
        channelId
        content
      }
    }
    """
  end

  test "new messages can be subscribed to", %{socket: socket, current_user: current_user} do
    channel = insert(:channel, server_id: current_user.server_id)
    insert(:channel_member, user_id: current_user.id, channel_id: channel.id)

    # setup a subscription
    ref = push_doc(socket, subscription(channel.id))
    assert_reply(ref, :ok, %{subscriptionId: subscription_id})

    # run a mutation to trigger the subscription
    ref = push_doc(socket, mutation(channel.id, "Hello world"))
    assert_reply(ref, :ok, reply)

    assert %{
             data: %{
               "createMessage" => %{
                 "channelId" => _,
                 "content" => "Hello world",
                 "id" => _
               }
             }
           } = reply

    # check to see if we got subscription data
    assert_push("subscription:data", push)

    assert %{
             result: %{data: %{"newMessage" => %{"message" => %{"content" => "Hello world"}}}},
             subscriptionId: subscription_id
           } == push
  end
end
