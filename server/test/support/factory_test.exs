defmodule Connect.FactoryTest do
  use ExUnit.Case
  import Connect.Factory
  import Cassandrax.Query

  defp schema_equal(a, b) do
    Map.delete(a, :__meta__) == Map.delete(b, :__meta__)
  end

  test "builds factory by name" do
    user = build(:user, name: "Chico").changes

    assert is_integer(user.id)
    assert is_integer(user.server_id)
    assert user.name == "Chico"
  end

  test "inserts factory by name" do
    user = insert(:user, name: "Chico")

    assert is_integer(user.id)
    assert is_integer(user.server_id)
    assert user.name == "Chico"

    db_user = Db.User |> where(server_id: user.server_id) |> where(id: user.id) |> Db.Repo.one()
    assert db_user == user
  end

  test "inserts factory by struct" do
    user = build(:user, name: "Chico")
    insert(user)
    user = struct(%Db.User{}, user.changes)

    db_user = Db.User |> where(server_id: user.server_id) |> where(id: user.id) |> Db.Repo.one()
    assert schema_equal(db_user, user)
  end

  test "allows overriding params" do
    msg = build(:message, channel_id: "1")

    assert msg.changes.channel_id == 1
  end
end
