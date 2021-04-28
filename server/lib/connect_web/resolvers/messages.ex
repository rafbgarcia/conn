defmodule ConnectWeb.Resolvers.Messages do
  alias Db.{Repo, Message}

  def create(_parent, args, %{context: %{current_user: current_user}}) do
    attrs = Map.put(args, :author_id, current_user.id)
    message = Repo.insert!(Message.new(attrs))

    {:ok, message}
  end

  def create(_parent, _args, _resolutions), do: {:error, :unauthorized}

  def edit(_parent, args, %{context: %{current_user: _}}) do
    message =
      Connect.get_message(args.channel_id, args.message_id)
      |> Message.edit(args)
      |> Repo.update!()

    {:ok, message}
  end

  def edit(_parent, _args, _resolutions), do: {:error, :unauthorized}
end
