# Figure out:
# 1-1 vs rooms
# create bookmarks for non-subscribed channels
# badges

defmodule ConnectWeb.Resolvers.Messages do
  # def list(_parent, _args, _resolution) do
  #   channels = [%{id: "a99c76f9-4d43-4125-94ba-4c6bddbcf370", name: "Rebels"}]
  #   {:ok, channels}
  # end

  def create(_parent, args, _resolution) do
    author_id = 1
    message = Db.Messages.create(args)

    {:ok, message}
  end
end
