defmodule ConnectWeb.Resolvers.Channels do
  def list(_parent, _args, _resolution) do
    channels = [%{id: "a99c76f9-4d43-4125-94ba-4c6bddbcf370", name: "Rebels"}]
    {:ok, channels}
  end
end
