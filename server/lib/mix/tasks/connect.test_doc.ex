defmodule Mix.Tasks.Connect.TestsDoc do
  use Mix.Task

  @shortdoc "Generates test doc"
  import ExUnit.CaptureIO

  def run(_args) do
    Mix.Task.run("app.start")

    result =
      capture_io(fn ->
        Mix.Task.run("test", [
          "--trace",
          "--cover",
          "test/graphql"
        ])
      end)

    {:ok, file} = File.open("./tests_doc", [:write])
    IO.binwrite(file, result)
    File.close(file)
  end
end
