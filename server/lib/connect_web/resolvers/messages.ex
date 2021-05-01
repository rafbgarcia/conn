defmodule ConnectWeb.Resolvers.Messages do
  alias Db.{Repo, Message, ThreadMessage}

  def list(_parent, args, %{context: %{current_user: _current_user}}) do
    message = Connect.channel_messages(args.channel_id)
    {:ok, message}
  end

  def list(_parent, _args, _resolutions), do: {:error, :unauthorized}

  def thread_messages(parent_message, _args, %{context: %{current_user: _current_user}}) do
    messages = Connect.thread_messages(parent_message.id)
    {:ok, messages}
  end

  def thread_messages(_parent, _args, _resolutions), do: {:error, :unauthorized}

  def create(_parent, args, %{context: %{current_user: current_user}}) do
    with true <- Connect.channel_member?(args.channel_id, current_user.id),
         true <- thread_in_channel?(args.channel_id, args[:parent_message_id]) do
      attrs = Map.put(args, :author_id, current_user.id)
      message = Repo.insert!(changeset(attrs))
      {:ok, message}
    else
      _ ->
        {:error, :unauthorized}
    end
  end

  def create(_parent, _args, _resolutions), do: {:error, :unauthorized}

  def edit(_parent, args, %{context: %{current_user: user}}) do
    message = Connect.get_message(args.channel_id, args.message_id)

    case message.author_id == user.id do
      true ->
        message =
          message
          |> Message.edit(args)
          |> Repo.update!()

        {:ok, message}

      false ->
        {:error, :unauthorized}
    end
  end

  def edit(_parent, _args, _resolutions), do: {:error, :unauthorized}

  defp changeset(attrs) when is_map_key(attrs, :parent_message_id), do: ThreadMessage.new(attrs)

  defp changeset(attrs), do: Message.new(attrs)

  defp thread_in_channel?(_, nil), do: true

  defp thread_in_channel?(channel_id, parent_message_id) do
    Connect.channel_message?(channel_id, parent_message_id)
  end
end
