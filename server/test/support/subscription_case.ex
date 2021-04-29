defmodule ConnectWeb.SubscriptionCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use ConnectWeb.ChannelCase
      use Absinthe.Phoenix.SubscriptionTest, schema: ConnectWeb.Schema

      setup do
        {jwt, user, _} = jwt()

        {:ok, socket} =
          ConnectWeb.UserSocket
          |> Phoenix.ChannelTest.connect(%{"authorization" => "Bearer #{jwt}"})

        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)

        {:ok, socket: socket, current_user: user}
      end
    end
  end
end
