
defmodule Day5 do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """


  def parse_line(line) do
    #parsing lines on the form X,Y -> Z,W
    # where, X, Y, Z, W are integers.
    line |> String.split(" -> ")
    |> Enum.map(fn(points) -> String.split(points, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple end)
    |> List.to_tuple
  end

  def read_data(fname) do
    {:ok, contents} = File.read(fname)
    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  def towards(a, b) do
    if a < b do
      a + 1
    else if a > b do
      a - 1
    else
      a
    end
    end
  end

  def draw_point(pos, picture) do
    Map.update(picture, pos, 1, &(&1 + 1))
  end


  def draw_line({{x0, y0}, {x0, y0}}, picture) do
    draw_point({x0, y0}, picture)
  end
  def draw_line({{x0, y0}, {x1, y1}}, picture) do
    new_pic = draw_point({x0, y0}, picture)
    draw_line({{towards(x0, x1), towards(y0, y1)}, {x1, y1}}, new_pic)
  end

  def run_a do
    data = read_data("day5_input.txt")
    |> Enum.filter(fn {{x0, y0}, {x1, y1}} -> x0 == x1 || y0 == y1 end)

    picture = data
    |> List.foldl(%{}, &draw_line/2)

    num_hazards = Enum.count(picture, fn {_, value} -> value >= 2  end)
    IO.puts(num_hazards)
  end

  def run_b do
    data = read_data("day5_input.txt")

    picture = data
    |> List.foldl(%{}, &draw_line/2)

    num_hazards = Enum.count(picture, fn {_, value} -> value >= 2  end)
    IO.puts(num_hazards)
  end
end

Day5.run_a()
Day5.run_b()
