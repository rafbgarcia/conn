# Figure out:
# 1-1 vs rooms
# create bookmarks for non-subscribed channels
# badges

defmodule ConnectWeb.Resolvers.Messages do
  alias Db.{Repo, Message}
  # def list(_parent, _args, _resolution) do
  #   channels = [%{id: "a99c76f9-4d43-4125-94ba-4c6bddbcf370", name: "Rebels"}]
  #   {:ok, channels}
  # end

  def create(_parent, args, %{context: %{current_user: current_user}}) do
    attrs = Map.put(args, :author_id, current_user.id)
    message = Repo.insert!(Message.new(attrs))

    {:ok, message}
  end

  def create(_parent, _args, _resolutions), do: {:error, :unauthorized}
end
