ExUnit.start()

defmodule ConnectTest.IntegrationCase do
  use ExUnit.CaseTemplate

  using options do
    quote bind_quoted: [
            truncate_tables: Keyword.get(options, :truncate_tables, []),
            case_template: __MODULE__
          ] do
      setup_all do
        case_template = unquote(case_template)
        case_template.create_schema()
      end

      setup do
        case_template = unquote(case_template)
        case_template.truncate_tables(unquote(truncate_tables))
        :ok
      end
    end
  end

  def create_schema do
    Mix.Task.run("connect.create_schema")
  end

  def truncate_tables(tables) do
    tables
    |> Enum.each(&Db.Base.exec("TRUNCATE TABLE #{&1}"))
  end
end
