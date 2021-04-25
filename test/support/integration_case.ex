defmodule IntegrationCase do
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
