ExUnit.start()

defmodule Mix.Tasks.Connect.TestsDoc do
  use Mix.Task

  @shortdoc "Generates test doc"
  import ExUnit.CaptureIO

  def run(_args) do
    Mix.Task.run("app.start")

    capture_io(fn ->
      Mix.Task.run("test", [
        "--trace",
        "--seed=1",
        "test/graphql"
      ])
    end)
    |> sanitize_tests()
    |> save_to_file("Acceptance")

    capture_io(fn -> Mix.Task.run("test.coverage") end)
    |> sanitize_coverage()
    |> save_to_file("Test Coverage")
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

  defp sanitize_coverage(text) do
    text
    |> String.replace("", "")
    |> String.replace(~r/\[\d*m */, "")
    |> String.split("\n")
    |> Enum.slice(2..-3)
    |> Enum.join("\n")
  end

  defp save_to_file(output, name) do
    {:ok, file} = File.open("../docs/#{name}.md", [:write])
    IO.binwrite(file, output)
    File.close(file)
  end
end
