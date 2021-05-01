bigint = Db.Snowflake.new()
list = 1..20 |> Enum.map(fn _ -> bigint end)

Benchee.run(
  %{
    "Enum.uniq" => fn -> Enum.uniq(list) end,
    "MapSet.new" => fn -> MapSet.new(list) end
  },
  time: 10,
  memory_time: 2
)


"""
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-8850H CPU @ 2.60GHz
Number of Available Cores: 12
Available memory: 16 GB
Elixir 1.11.4
Erlang 23.3.1

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 10 s
memory time: 2 s
parallel: 1
inputs: none specified
Estimated total run time: 28 s

Benchmarking Enum.uniq...
Benchmarking MapSet.new...

Name                 ips        average  deviation         median         99th %
MapSet.new        1.15 M        0.87 μs  ±5311.34%        0.90 μs        1.90 μs
Enum.uniq         0.94 M        1.07 μs  ±3176.19%        0.90 μs        1.90 μs

Comparison:
MapSet.new        1.15 M
Enum.uniq         0.94 M - 1.23x slower +0.197 μs

Memory usage statistics:

Name          Memory usage
MapSet.new         1.05 KB
Enum.uniq        0.0625 KB - 0.06x memory usage -0.99219 KB
"""
