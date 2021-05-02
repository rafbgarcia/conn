defmodule Mix.Tasks.Connect.AcceptanceDoc do
  use Mix.Task

  @shortdoc "Generates Acceptance doc under the docs folder"

  ExUnit.start()
  import ExUnit.CaptureIO

  def run(_args) do
    Mix.Task.run("app.start")

    capture_io(fn -> Mix.Task.run("test", ["--trace", "--seed=0", "test/graphql"]) end)
    |> sanitize_tests()
    |> save_to_file("Acceptance")
  end

  defp sanitize_tests(text) do
    text
    |> String.split("\n")
    |> Enum.slice(1..-7)
    |> Enum.map(fn line ->
      Regex.named_captures(~r/(?<mod>Connect\.Graphql.+) \[(?<file>test\/.+\.exs)\]/, line)
      |> case do
        nil ->
          line

        %{"mod" => module_name, "file" => file} ->
          {module, _} = Code.compile_file(file) |> Enum.at(0)

          String.replace(line, module_name, "### Scenario: #{module.scenario()}\n")
      end
    end)
    |> Enum.join("\n")
    |> String.replace(~r/[\[\(][^\n]*/, "")
    |> String.replace(~r/test /i, "")
  end

  defp save_to_file(output, name) do
    {:ok, file} = File.open("../docs/#{name}.md", [:write])
    IO.binwrite(file, output)
    File.close(file)
  end
end
