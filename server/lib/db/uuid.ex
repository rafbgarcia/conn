defmodule Db.UUID do
  # Time-aware sortable UUID.
  # Used, for example, to sort messages by clustering key ID.
  def timeuuid do
    UUID.uuid1()
  end

  def uuid do
    UUID.uuid4()
  end

  @doc """
  Converts a timeuuid to datetime

  Implementation reference: https://stackoverflow.com/a/26915856/1488741
  """
  def to_datetime(uuid) do
    parts = String.split(uuid, "-")

    time_str = [
      String.slice(Enum.at(parts, 2), 1..-1),
      Enum.at(parts, 1),
      Enum.at(parts, 0)
    ]

    {num, _} = Enum.join(time_str, "") |> Integer.parse(16)

    (num - 122_192_928_000_000_000)
    |> Integer.floor_div(10_000)
    |> DateTime.from_unix!(:millisecond)
  end
end
