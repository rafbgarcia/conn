defmodule ConnectWeb.Resolvers.Badges do
  def update(_parent, _args, %{context: %{current_user: _current_user}}) do
    {:ok, %{}}
  end

  def update(_parent, _args, _resolutions), do: {:error, :unauthorized}
end
