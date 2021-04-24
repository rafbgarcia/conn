defmodule Db.Servers do
  def create(%{name: name}) do
    id = Db.UUID.uuid()

    Db.Base.exec(
      "INSERT INTO servers (id, name) VALUES(:id, :name)",
      %{
        id: {"uuid", id},
        name: {"text", name}
      }
    )

    id
  end
end
