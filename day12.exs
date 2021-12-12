#! /usr/bin/env elixir

defmodule Day12 do

  defp register_edge([a, b], m) do
    m
    |> Map.update(a, [b], &([b|&1]))
    |> Map.update(b, [a], &([a|&1]))
  end
  defp read_data(fname) do
    {:ok, contents} = File.read(fname)
    connections = contents
    |> String.split("\n", trim: true)
    |> Enum.map(&(&1 |> String.split("-", trim: true)))

    Enum.reduce(connections, %{}, &register_edge/2)
  end

  defp upcase?(input), do: input == String.upcase(input)

  defp maybe_register_visit(visited, node) do
    if upcase?(node) do
      visited
    else
      MapSet.put(visited, node)
    end
  end

  defp count_paths(b, b, _, count, _) do
    count+1
  end

  defp count_paths(a, b, edges, count, visited) do
    if MapSet.member?(visited, a) do
      count
    else
      visited = maybe_register_visit(visited, a)
      Enum.reduce(edges[a], count, fn n, c -> count_paths(n, b, edges, c, visited) end)
    end
  end


  defp count_paths(a, b, edges) do
    count_paths(a, b, edges, 0, MapSet.new())
  end

  def run_a do
    edges = read_data("day12_input.txt")
    IO.puts(count_paths("start", "end", edges))
  end

  defp count_paths_b(b, b, _, count, _, _) do
    count+1
  end

  defp count_paths_b(a, b, edges, count, visited, small_visited_twice) do
    if MapSet.member?(visited, a) do
      if small_visited_twice or a == "start" or a == "end" do
        count
      else
        Enum.reduce(edges[a], count, fn n, c -> count_paths_b(n, b, edges, c, visited, true) end)
      end
    else
      visited = maybe_register_visit(visited, a)
      Enum.reduce(edges[a], count, fn n, c -> count_paths_b(n, b, edges, c, visited, small_visited_twice) end)
    end
  end


  defp count_paths_b(a, b, edges) do
    count_paths_b(a, b, edges, 0, MapSet.new(), false)
  end

  def run_b do
    edges = read_data("day12_input.txt")
    IO.puts(count_paths_b("start", "end", edges))
  end

end

Day12.run_a()
Day12.run_b()
