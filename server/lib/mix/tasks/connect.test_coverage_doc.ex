ExUnit.start()

defmodule Mix.Tasks.Connect.TestCoverageDoc do
  use Mix.Task

  @shortdoc "Generates Test Coverage under the docs folder"
  import ExUnit.CaptureIO

  def run(_args) do
    Mix.Task.run("app.start")

    capture_io(fn -> Mix.Task.run("test", ["--cover"]) end)
    |> sanitize_coverage()
    |> save_to_file("Test Coverage")
  end

  defp sanitize_coverage(text) do
    text
    |> String.replace("", "")
    |> String.replace(~r/\[\d*m */, "")
    |> String.split("\n")
    |> Enum.slice(10..-3)
    |> Enum.join("\n")
  end

  defp save_to_file(output, name) do
    {:ok, file} = File.open("../docs/#{name}.md", [:write])
    IO.binwrite(file, output)
    File.close(file)
  end
end
