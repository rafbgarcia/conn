defmodule IntegrationCaseTest do
  use IntegrationCase, truncate_tables: [:messages]

  alias Db.{Repo, Message, UUID}

  describe "truncate_table" do
    test "records created in one test case" do
      Repo.insert!(Message.new(%{channel_id: UUID.uuid(), content: "hey", author_id: 2}))
      assert Kernel.length(Repo.all(Message)) == 1
    end

    test "do not leak to other test cases" do
      assert Kernel.length(Repo.all(Message)) == 0
    end
  end
end
