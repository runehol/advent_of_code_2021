#! /usr/bin/env elixir

defmodule Day14 do

  defp map_representation(str) do
    list = String.to_charlist(str)

    Enum.zip(list, Enum.drop(list, 1) ++ [?_])
    |> Enum.reduce(%{}, fn {a, b}, map ->
      Map.update(map, <<a, b>>, 1, &(&1+1))
    end)
  end

  defp read_data(fname) do
    {:ok, contents} = File.read(fname)
    lines = contents
    |> String.split("\n", trim: true)

    start = map_representation(hd(lines))

    rules_lines = lines
    |> Enum.drop(1)

    rules =
      for <<a, b, _, _, _, _, c>> <- rules_lines, into: %{}, do: {<<a, b>>, {<<a, c>>, <<c, b>>}}

    {start, rules}
  end


  defp polymerise_step(map, rules) do
    Enum.reduce(map, %{}, fn {key, count}, res ->
      r = rules[key]
      if r do
        {r1, r2} = r
        res
        |> Map.update(r1, count, &(&1+count))
        |> Map.update(r2, count, &(&1+count))
      else
        res
        |> Map.update(key, count, &(&1+count))
        end
    end)
  end

  def stats(expr) do
    frequencies = expr
    |> Enum.reduce(%{}, fn {<<p, _>>, count}, map ->
      Map.update(map, <<p>>, count, &(&1+count))
    end)
    |> Enum.map(fn {k, freq} -> {freq, k} end)
    |> Enum.sort

    {least_common, _} = List.first(frequencies)
    {most_common, _} = List.last(frequencies)
    most_common - least_common
  end

  def run_a do
    {start, rules} = read_data("day14_test_input.txt")
    polymer = Enum.reduce(1..10, start, fn _, p -> polymerise_step(p, rules) end)

    IO.puts(stats(polymer))
  end


  def run_b do
    {start, rules} = read_data("day14_input.txt")
    polymer = Enum.reduce(1..40, start, fn _, p -> polymerise_step(p, rules) end)

    IO.puts(stats(polymer))
  end

end

Day14.run_a()
Day14.run_b()
