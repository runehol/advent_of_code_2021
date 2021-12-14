#! /usr/bin/env elixir

defmodule Day14 do

  defp read_data(fname) do
    {:ok, contents} = File.read(fname)
    lines = contents
    |> String.split("\n", trim: true)

    start = hd(lines) |> String.to_charlist()

    rules_lines = lines
    |> Enum.drop(1)
    |> Enum.map(&String.to_charlist/1)

    rules =
      for [a, b, _, _, _, _, c] <- rules_lines, into: %{}, do: {{a,b}, c}

    {start, rules}
  end


  defp polymerise_step([a], _, acc) do
    Enum.reverse([a|acc])
  end

  defp polymerise_step([a, b | rest], rules, acc) do
    rule_result = rules[{a, b}]
    if rule_result do
      polymerise_step([b|rest], rules, [rule_result, a | acc])
    else
      polymerise_step([b|rest], rules, [a | acc])
    end
  end

  def stats(expr) do
    expr |> Enum.reduce(%{}, fn p, map ->
      Map.update(map, p, 1, &(&1+1))
    end)
  end

  def run_a do
    {start, rules} = read_data("day14_input.txt")
    polymer = Enum.reduce(1..10, start, fn _, p -> polymerise_step(p, rules, []) end)

    frequencies = polymer
    |> stats
    |> Enum.map(fn {k, freq} -> {freq, k} end)
    |> Enum.sort

    {least_common, _} = List.first(frequencies)
    {most_common, _} = List.last(frequencies)
    IO.puts(most_common - least_common)
  end


  def run_b do
    {start, rules} = read_data("day14_input.txt")
    polymer = Enum.reduce(1..40, start, fn s, p ->
      IO.puts(s)
      polymerise_step(p, rules, [])
    end)

    frequencies = polymer
    |> stats
    |> Enum.map(fn {k, freq} -> {freq, k} end)
    |> Enum.sort

    {least_common, _} = List.first(frequencies)
    {most_common, _} = List.last(frequencies)
    IO.puts(most_common - least_common)
  end

end

Day14.run_a()
Day14.run_b()
