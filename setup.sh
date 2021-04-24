# Install Erlang dependencies
brew install autoconf

# Add Erlang and Elixir plugins
asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

# Install plugins based on .tool-versions
asdf install

# Install/update Hex
mix local.hex

# Install Phoenix
mix archive.install hex phx_new 1.5.8

# Install deps
mix setup
