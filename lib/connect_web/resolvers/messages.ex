defmodule ConnectWeb.Resolvers.Messages do
  # def list(_parent, _args, _resolution) do
  #   channels = [%{id: "a99c76f9-4d43-4125-94ba-4c6bddbcf370", name: "Rebels"}]
  #   {:ok, channels}
  # end

  def create(_parent, args, _resolution) do
    {:ok,
     %{
       id: "MessageID",
       channel_id: args.channel_id,
       content: args.content
     }}
  end
end
