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


defmodule Day21 do
  use Memoize

  defp read_data(fname) do
    {:ok, contents} = File.read(fname)

    contents
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_, _, pos] = Regex.run(~r/^Player (\d+) starting position: (\d+)$/, line)
      String.to_integer(pos)
    end)
  end

  defp board_pos(curr_pos, roll), do: rem((curr_pos + roll - 1), 10) + 1

  defp play_a({_, turn_score, _, other_score}, die) when other_score >= 1000 do
    turn_score * die.rolls
  end

  defp play_a({turn_pos, turn_score, other_pos, other_score}, die) do
    {roll, die} = Die.roll3(die)
    new_pos = board_pos(turn_pos, roll)
    turn_score = turn_score + new_pos
    turn_pos = new_pos
    play_a({other_pos, other_score, turn_pos, turn_score}, die)
  end

  def run_a do
    [player_1_pos, player_2_pos] = read_data("day21_input.txt")
    IO.puts(play_a({player_1_pos, 0, player_2_pos, 0}, Die.new))
  end

  defmemo play_b({_, _, _, other_score}) when other_score >= 21 do
    {0, 1}
  end

  @die_rolls for a <- 1..3, b <- 1..3, c<- 1..3, do: a+b+c

  defmemo play_b({turn_pos, turn_score, other_pos, other_score}) do
    Enum.reduce(@die_rolls, {0, 0}, fn roll, {sum_turn, sum_other} ->
      new_pos = board_pos(turn_pos, roll)
      turn_score = turn_score + new_pos
      turn_pos = new_pos
      {other_wins, turn_wins} = play_b({other_pos, other_score, turn_pos, turn_score})
      {sum_turn + turn_wins, sum_other + other_wins}
    end)
  end

  def run_b do
    [player_1_pos, player_2_pos] = read_data("day21_input.txt")
    wins = play_b({player_1_pos, 0, player_2_pos, 0})
    IO.inspect(wins)
    IO.puts(Enum.max(Tuple.to_list(wins)))
  end



end

Day21.run_a()
Day21.run_b()
