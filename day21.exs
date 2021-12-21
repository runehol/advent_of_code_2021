#! /usr/bin/env elixir
defmodule Die do
  defstruct value: 1, rolls: 0

  def new(value \\ 1, rolls \\ 0) do
    %Die{value: value, rolls: rolls}
  end

  defp wrap(value) when value > 100, do: wrap(value-100)
  defp wrap(value), do: value

  def roll(%Die{value: value, rolls: rolls}) do
    {value, Die.new(wrap(value+1), rolls+1)}
  end

  def roll3(%Die{value: value, rolls: rolls}) do
    res = value + value+1 + value+2
    {res, Die.new(wrap(value+3), rolls+3)}
  end

end

defmodule Player do
  defstruct name: "Unknown", position: 0, score: 0

  def new(name, start_pos) do
    %Player{name: name, position: start_pos}
  end

  def move(%Player{score: score}=player, new_pos) do
    %Player{player | score: score+new_pos, position: new_pos}
  end
end

defmodule Day21 do

  defp read_data(fname) do
    {:ok, contents} = File.read(fname)

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_, name, pos] = Regex.run(~r/^Player (\d+) starting position: (\d+)$/, line)
      Player.new(name, String.to_integer(pos))
    end)
  end

  defp board_pos(curr_pos, roll), do: rem((curr_pos + roll - 1), 10) + 1

  defp win(_, losing_player, die) do
    losing_player.score * die.rolls
  end

  defp play(turn_player, other_player, die) do
    {roll, die} = Die.roll3(die)
    new_pos = board_pos(turn_player.position, roll)
    turn_player = Player.move(turn_player, new_pos)
    if turn_player.score >= 1000 do
      win(turn_player, other_player, die)
    else
      play(other_player, turn_player, die)
    end
  end

  def run_a do
    [player_1, player_2] = read_data("day21_input.txt")
    IO.puts(play(player_1, player_2, Die.new))
  end

  def run_b do
  end



end

Day21.run_a()
Day21.run_b()
