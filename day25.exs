#! /usr/bin/env elixir
defmodule Floor do
  defstruct map: %{}, height: 0, width: 0



  def read(lines) do
    vals = Enum.with_index(lines, fn line, y ->
      Enum.with_index(String.to_charlist(line), fn ch, x ->
        {{y, x}, ch}
      end)
    end)
    |> Enum.concat
    |> Enum.filter(fn {_, v} -> v != ?. end)
    %Floor{map: Map.new(vals), height: length(lines), width: String.length(hd(lines))}
  end

  def print(%Floor{map: map, width: width, height: height}=floor) do
    io_data = Enum.map(0..height-1, fn y ->
      [Enum.map(0..width-1, fn x ->
         Map.get(map, {y, x}, ?.)
      end), "\n"]
    end)
    IO.puts(io_data)
    floor
  end

  def empty_pos(%Floor{map: map}, pos) do
    !Map.has_key?(map, pos)
  end

  def right_pos(%Floor{width: width}, {y, x}), do: {y, rem(x+1, width)}
  def down_pos(%Floor{height: height}, {y, x}), do: {rem(y+1, height), x}

  def possibly_move(floor, pos, npos, sym, sym) do
    if empty_pos(floor, npos) do
      {npos, sym}
    else
      {pos, sym}
    end
  end

  def possibly_move(_, pos, _, sym, _) do
    {pos, sym}
  end

  def step_right(%Floor{map: map}=floor) do
    new_map = for {pos, v} <- map, into: %{}, do: possibly_move(floor, pos, right_pos(floor, pos), v, ?>)
    %Floor{floor | map: new_map}
  end

  def step_down(%Floor{map: map}=floor) do
    new_map = for {pos, v} <- map, into: %{}, do: possibly_move(floor, pos, down_pos(floor, pos), v, ?v)
    %Floor{floor | map: new_map}
  end

  def step(floor) do
    floor
    |> step_right
    |> step_down
  end
end


defmodule Day25 do

  defp read_data(fname) do
    File.read!(fname)
    |> String.split("\n", trim: true)
    |> Floor.read
  end

  def step_until_stationary(floor, count) do
    nfloor = Floor.step(floor)
    if floor == nfloor do
      Floor.print(floor)
      IO.puts("Count: #{count}")
    else
      step_until_stationary(nfloor, count+1)
    end
  end

  def run_a do
    floor = read_data("day25_input.txt")

    step_until_stationary(floor, 1)
   end

  def run_b do
  end



end

Day25.run_a()
Day25.run_b()
