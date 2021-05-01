defmodule Mix.Tasks.Connect.TestsDoc do
  use Mix.Task

  @shortdoc "Generates test doc"
  import ExUnit.CaptureIO

  def run(_args) do
    Mix.Task.run("app.start")

    capture_io(fn ->
      Mix.Task.run("test", [
        "--trace",
        "test/graphql"
      ])
    end)
    |> sanitize_tests()
    |> save_to_file("GraphQL Queries Test Cases")

    capture_io(fn -> Mix.Task.run("test.coverage") end)
    |> sanitize_coverage()
    |> save_to_file("Test Coverage")
  end

  defp sanitize_tests(text) do
    text
    |> String.split("\n")
    |> Enum.slice(1..-7)
    |> Enum.join("\n")
    |> String.replace(~r/[\[\(][^\n]*/, "")
    |> String.replace("Connect.Graphql.", "### ")
    |> String.replace(~r/test /i, "")
  end

  defp sanitize_coverage(text) do
    text
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
