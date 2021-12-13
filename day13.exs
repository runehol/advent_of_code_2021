#! /usr/bin/env elixir

defmodule Day13 do

  defp parse_points(lines) do
    lines
    |> Enum.filter(&(String.contains?(&1, ",")))
    |> Enum.map(fn line ->
      String.split(line, ",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple
     end)
    |> Enum.reduce(MapSet.new(),
    fn pos, acc ->
      MapSet.put(acc, pos)
    end)
  end

  def parse_instructions(lines) do
    lines
    |> Enum.filter(&(String.contains?(&1, "=")))
    |> Enum.map(fn line ->
      v = String.split(line, "=")
      {Enum.at(v, 0), String.to_integer(Enum.at(v, 1))}
    end)
  end

  defp read_data(fname) do
    {:ok, contents} = File.read(fname)
    lines = contents
    |> String.split("\n", trim: true)

    points = parse_points(lines)
    instructions = parse_instructions(lines)
    {points, instructions}
  end

  defp apply_instruction({"fold along x", v}, points) do
    Enum.reduce(points, MapSet.new(), fn {x, y}, set ->
      x = if x > v, do: 2*v - x, else: x
      MapSet.put(set, {x, y})
    end)
  end

  defp apply_instruction({"fold along y", v}, points) do
    Enum.reduce(points, MapSet.new(), fn {x, y}, set ->
      y = if y > v, do: 2*v - y, else: y
      MapSet.put(set, {x, y})
    end)
  end

  def run_a do
    {points, instructions} = read_data("day13_input.txt")
    res = Enum.reduce(Enum.take(instructions, 1), points, &apply_instruction/2)
    IO.puts(MapSet.size(res))
  end


  defp print_set(set) do
    max_x = Enum.map(set, fn {x, _} -> x end) |> Enum.max
    max_y = Enum.map(set, fn {_, y} -> y end) |> Enum.max
    Enum.map(0..max_y, fn y ->
      [Enum.map(0..max_x, fn x ->
        if MapSet.member?(set, {x, y}), do: "#", else: "."
      end),
      "\n"]
    end) |> IO.puts
  end

  def run_b do
    {points, instructions} = read_data("day13_input.txt")
    res = Enum.reduce(instructions, points, &apply_instruction/2)
    print_set(res)
  end

end

Day13.run_a()
Day13.run_b()
