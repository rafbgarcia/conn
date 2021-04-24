defmodule Mix.Tasks.Connect.Seed do
  use Mix.Task

  @shortdoc "Seed for development"

  def run(_args) do
    Mix.Task.run("app.start")

    server_id = Db.Servers.create(%{name: "Power"})
    channel_id = Db.Channels.create(%{server_id: server_id, name: "Rebels"})
    Db.Messages.create(%{channel_id: channel_id, content: "Hello 1"})
    Db.Messages.create(%{channel_id: channel_id, content: "Hello 2"})
    Db.Messages.create(%{channel_id: channel_id, content: "Hello 3"})
    Db.Messages.create(%{channel_id: channel_id, content: "Hello 4"})
    Db.Messages.create(%{channel_id: channel_id, content: "Hello 5"})
  end
end
