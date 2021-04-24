defmodule Db.Channels do
  def create(%{server_id: server_id, name: name}) do
    id = Db.UUID.timeuuid()

    Db.Base.exec(
      """
      INSERT INTO channels (server_id, id, name, hidden)
      VALUES(:server_id, :id, :name, :hidden)
      """,
      %{
        server_id: {"uuid", server_id},
        id: {"timeuuid", id},
        name: {"text", name},
        hidden: {"boolean", false}
      }
    )

    id
  end
end
