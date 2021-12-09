#! /usr/bin/env elixir

defmodule Day9 do



  defp read_data(fname) do
    {:ok, contents} = File.read(fname)
    elements = contents
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)

    m = elements
    |> Enum.with_index(fn elements, y -> Enum.with_index(elements, &({{y, &2}, &1-?0})) end)
    |> Enum.concat
    |> Map.new

    dims = {length(elements), length(hd(elements))}
    {dims, m}
  end

  defp access(m, {y, x}) do
    Map.get(m, {y, x}, 9)
  end

  defp neighbours({y, x}) do
    [{y, x-1}, {y, x+1}, {y-1, x}, {y+1, x}]
  end

  defp find_low_points({h, w}, map) do
    Enum.flat_map(0..h-1, fn y ->
      Enum.flat_map(0..w-1, fn x ->
        pos = {y, x}
        center = access(map, pos)
        is_low_point = Enum.reduce(neighbours(pos), true, fn npos, acc ->
          acc && center < access(map, npos)
        end)
        if is_low_point, do: [{y,x}], else: []
      end)
    end)
  end


  defp fill_basin(pos, map, parent_height, size, visited) do
    pos_height = access(map, pos)
    cond do
      MapSet.member?(visited, pos)    -> {size, visited}
      parent_height >= pos_height     -> {size, visited}
      pos_height >= 9                 -> {size, visited}
      true                            ->
        visited = MapSet.put(visited, pos)
        size = size + 1
        Enum.reduce(neighbours(pos), {size, visited}, fn npos, {size, visited} ->
          fill_basin(npos, map, pos_height, size, visited)
        end)
    end
  end

  defp basin_size(pos, map) do
    {size, _} = fill_basin(pos, map, -1, 0, MapSet.new())
    size
  end

  def run_a do
    {dims, map} = read_data("day9_input.txt")

    low_points = find_low_points(dims, map)
    risk = Enum.reduce(low_points, 0, fn pos, acc ->
      risk_level = access(map, pos) + 1
      acc + risk_level
    end)
    IO.puts(risk)
  end


  def run_b do
    {dims, map} = read_data("day9_input.txt")

    low_points = find_low_points(dims, map)
    basins = Enum.map(low_points, &basin_size(&1, map))
    result = Enum.sort(basins, :desc)
    |> Enum.take(3)
    |> Enum.product
    IO.puts(result)
  end

end

Day9.run_a()
Day9.run_b()
