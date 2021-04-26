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

# Setup project
make start
echo ">>> ScyllaDB may take a while to load. Waiting 30 seconds before creating DB"
sleep 30
mix setup
MIX_ENV=test mix connect.create_schema
