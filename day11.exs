#! /usr/bin/env elixir

defmodule Day11 do



  defp read_data(fname) do
    {:ok, contents} = File.read(fname)
    elements = contents
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)

    elements
    |> Enum.with_index(fn elements, y -> Enum.with_index(elements, &({{y, &2}, &1-?0})) end)
    |> Enum.concat
    |> Map.new
  end

  defp neighbours({y, x}) do
    [{y, x-1}, {y, x+1}, {y-1, x}, {y+1, x}, {y-1, x-1}, {y-1, x+1}, {y+1, x-1}, {y+1,x+1}]
  end

  defp inc_with_propagation(m, {y, x}) do
    if x < 0 || x >= 10 || y < 0 || y >= 10 do
      m
    else
      k = {y, x}
      m = Map.update(m, k, 1, &(&1+1))
      if Map.get(m, k) != 10 do
        m
      else
        Enum.reduce(neighbours(k), m, &(inc_with_propagation(&2, &1)))
      end
    end
  end

  defp count_flashes_and_reset(m) do
    Enum.reduce(m, {%{}, 0}, fn {key, val}, {m2, n_flashes} ->
      if val < 10 do
        {Map.put(m2, key, val), n_flashes}
      else
        {Map.put(m2, key, 0), n_flashes+1}
      end
    end)
  end


  defp inc_map(initial_map) do
    Enum.reduce(0..9, initial_map, fn y, map ->
      Enum.reduce(0..9, map, fn x, map ->
        inc_with_propagation(map, {y, x})
      end)
    end)
  end

  def step(map) do
    map
    |> inc_map
    |> count_flashes_and_reset
  end


  def run_a do
    map = read_data("day11_input.txt")
    {_, n_flashes} = Enum.reduce(1..100, {map, 0}, fn _, {map, count} ->
      {m2, c} = step(map)
      {m2, c+count}
    end)
    IO.puts(n_flashes)
  end

  def step_until_all_flashes(map, idx) do
    {m2, n_flashes} = step(map)
    if n_flashes == 100 do
      idx
    else
      step_until_all_flashes(m2, idx+1)
    end
  end

  def run_b do
    map = read_data("day11_input.txt")
    IO.puts(step_until_all_flashes(map, 1))
  end

end

Day11.run_a()
Day11.run_b()
