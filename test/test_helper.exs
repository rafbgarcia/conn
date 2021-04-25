ExUnit.start()

defmodule ConnectTest.IntegrationCase do
  use ExUnit.CaseTemplate

  using options do
    quote bind_quoted: [
            truncate_tables: Keyword.get(options, :truncate_tables, []),
            case_template: __MODULE__
          ] do
      setup do
        case_template = unquote(case_template)
        case_template.truncate_tables(unquote(truncate_tables))
        :ok
      end
    end
  end

  def truncate_tables(tables) do
    tables
    |> Enum.each(&({:ok, _} = Db.Repo.exec("TRUNCATE TABLE #{Db.Repo.keyspace()}.#{&1}")))
  end
end

defmodule IntegrationCaseTest do
  use ConnectTest.IntegrationCase, truncate_tables: [:messages]

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
