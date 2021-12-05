#! /usr/bin/env elixir

defmodule Day4 do


  def parse_board(board_lines) do
    board_lines

    |> Enum.map(fn line -> String.split(line, " ", trim: true) |> Enum.map(&String.to_integer/1) end)
    # now in turn, wrap each value up with its index
    |> Enum.with_index(fn elements, y -> Enum.with_index(elements, &({{y, &2}, &1})) end)
    |> Enum.concat

  end

  def read_data(fname) do
    {:ok, contents} = File.read(fname)
    [num_line | rest] = contents
    |> String.split("\n", trim: true)

    numbers = num_line |> String.split(",") |> Enum.map(&String.to_integer/1)

    bingo_boards = rest
    |> Enum.chunk_every(5)
    |> Enum.map(&parse_board/1)

    {numbers, bingo_boards}
  end


  def mark_board({board_values, board_state}, called_value) do
    new_board_state = List.foldl(board_values, board_state, fn {pos, val}, bstate ->
      if val == called_value do
        Map.put(bstate, pos, true)
      else
        bstate
      end
    end)
    {board_values, new_board_state}
  end


  def winning_boards() do
    n = 5
    range = 0..n-1
    horisontals = range |> Enum.map(fn y -> Enum.map(range, &({y, &1})) end)
    verticals = range |> Enum.map(fn x -> Enum.map(range, &({&1, x})) end)
    Enum.concat(horisontals, verticals)
  end

  def is_winning({_, board_state}, winners) do
    winners |> Enum.map(fn positions ->
      Enum.reduce(positions, true, fn pos, so_far ->
        so_far && Map.get(board_state, pos)
      end)
    end) |> Enum.any?()
  end


  def winning_score({board_values, board_state}, winners) do
    if is_winning({board_values, board_state}, winners) do
      Enum.reduce(board_values, 0, fn {pos, value}, score_so_far ->
        if Map.get(board_state, pos) do
          score_so_far
        else
          score_so_far + value
        end
      end)
    else
      0
    end
  end

  def play_well([], _, _) do
    0
  end

  def play_well([num|rest_numbers], boards, winners) do
    new_boards = Enum.map(boards, &(mark_board(&1, num)))
    winner = (Enum.map(new_boards, &(winning_score(&1, winners))) |> Enum.max)
    if winner > 0 do
      winner * num
    else
      play_well(rest_numbers, new_boards, winners)
    end
  end


  def run_a do
    {numbers, board_values} = read_data("day4_input.txt")
    boards = Enum.map(board_values, fn board -> {board, %{}} end)

    score = play_well(numbers, boards, winning_boards())
    IO.puts(score)
  end


  def play_badly([], _, _) do
    0
  end

  def play_badly([num|rest_numbers], boards, winners) do
    new_boards = Enum.map(boards, &(mark_board(&1, num)))
    new_boards = if length(new_boards) > 1 do
      # we filter out the winning boards as they arrive
      Enum.filter(new_boards, &(!is_winning(&1, winners)))
    else
      new_boards
    end
    winner = (Enum.map(new_boards, &(winning_score(&1, winners))) |> Enum.max)
    if winner > 0 do
      winner * num
    else
      play_badly(rest_numbers, new_boards, winners)
    end
  end


  def run_b do
    {numbers, board_values} = read_data("day4_input.txt")
    boards = Enum.map(board_values, fn board -> {board, %{}} end)

    score = play_badly(numbers, boards, winning_boards())
    IO.puts(score)
  end


end

Day4.run_a()
Day4.run_b()
