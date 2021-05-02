defmodule Connect.Unit.ChannelTest do
  use ExUnit.Case

  test "types" do
    assert Db.Channel.types() == %{
             broadcasting: "BROADCASTING",
             direct: "DIRECT",
             group: "GROUP",
             private: "PRIVATE",
             public: "PUBLIC"
           }
  end

  test "validates type" do
    %{type: error} = Db.Channel.new(%{type: "INVALID"}).errors |> Enum.into(%{})

    assert error ==
             {"is invalid",
              [
                validation: :inclusion,
                enum: ["BROADCASTING", "DIRECT", "GROUP", "PRIVATE", "PUBLIC"]
              ]}
  end
end
