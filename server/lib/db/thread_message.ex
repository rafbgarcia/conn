defmodule Db.ThreadMessage do
  use Cassandrax.Schema
  import Ecto.Changeset

  alias Db.{UUID, ThreadMessage}

  @primary_key [:parent_message_id, :id]

  table "thread_messages" do
    field(:channel_id, :string)
    field(:parent_message_id, :string)
    field(:id, :string)
    field(:content, :string)
    field(:author_id, :integer)
    field(:created_at, :utc_datetime)
    field(:edited_at, :utc_datetime)
  end

  def new(attrs) do
    id = UUID.timeuuid()

    attrs =
      attrs
      |> Map.put(:id, id)
      |> Map.put(:created_at, DateTime.utc_now())

    cast(%ThreadMessage{}, attrs, [
      :parent_message_id,
      :id,
      :channel_id,
      :content,
      :author_id,
      :created_at
    ])
    |> validate_required([:parent_message_id, :id, :channel_id, :author_id, :created_at])
  end

  def edit(message, attrs) do
    message
    |> change(content: attrs.content)
    |> change(edited_at: DateTime.truncate(DateTime.utc_now(), :second))
  end
end
