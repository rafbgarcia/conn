defmodule Connect.UUIDTest do
  use ExUnit.Case

  alias Db.UUID

  test "converts UUID v1 to DateTime" do
    # Got the UUID below from message's ID in the messages table
    uuid = "cd102294-a60a-11eb-9b72-acde48001122"

    assert UUID.to_datetime(uuid) == ~U[2021-04-25 21:11:28.520Z]
  end
end
