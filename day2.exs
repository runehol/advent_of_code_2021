#! /usr/bin/env elixir

defmodule Day2 do

  defp read_data(fname) do
    File.stream!(fname)
    |> Enum.map(fn line ->
      [_, cmdstr, value] = Regex.run(~r/(forward|up|down) (\d+)\n/, line)
      cmd = case cmdstr do
        "forward" -> :forward
        "up" -> :up
        "down" -> :down
      end
      {cmd, String.to_integer(value)}
    end)
  end

  def steer1({:forward, value}, {pos, depth}), do: {pos+value, depth}
  def steer1({:down, value}, {pos, depth}), do: {pos, depth+value}
  def steer1({:up, value}, {pos, depth}), do: {pos, depth-value}

  def run_a do
    cmds = read_data("day2_input.txt")
    {pos, depth} = Enum.reduce(cmds, {0, 0}, &steer1/2)
    IO.puts(pos*depth)
  end

  def steer2({:forward, value}, {pos, depth, aim}), do: {pos+value, depth+aim*value, aim}
  def steer2({:down, value}, {pos, depth, aim}), do: {pos, depth, aim+value}
  def steer2({:up, value}, {pos, depth, aim}), do: {pos, depth, aim-value}

  def run_b do
    cmds = read_data("day2_input.txt")
    {pos, depth, _} = Enum.reduce(cmds, {0, 0, 0}, &steer2/2)
    IO.puts(pos*depth)
  end



end

Day2.run_a()
Day2.run_b()
