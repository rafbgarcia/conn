Connect.FactorySequence.start_link([])

# Why max_cases 1?
# Common Phoenix and Ecto projects run tests in a Sandbox,
# hence they don't affect each other and can run in parallel.
#
# There is not tool available at this moment that does the
# same for Cassandra/ScyllaDB.
ExUnit.start(max_cases: 1)
