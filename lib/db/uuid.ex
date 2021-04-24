defmodule Db.UUID do
  # Time-aware sortable UUID.
  # Used, for example, to sort messages by clustering key ID.
  def timeuuid do
    UUID.uuid1()
  end

  def uuid do
    UUID.uuid4()
  end
end
