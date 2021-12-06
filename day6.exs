#! /usr/bin/env elixir

defmodule Day6 do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """


  def read_data(fname) do
    {:ok, contents} = File.read(fname)
    contents
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def instances_to_counts(instances, new_spawn_period \\ 9) do
    count_map = Enum.reduce(instances, %{}, fn elm, m ->
      Map.update(m, elm, 1, &(&1 + 1))
    end)

    initial_lst = List.duplicate(0, new_spawn_period)
    Enum.reduce(count_map, initial_lst, fn {day, n}, lst ->
      List.replace_at(lst, day, n)
    end)
  end

  def step_day(state, birth_period \\ 6) do
    [birthing|rest] = state
    state2 = Enum.concat(rest, [birthing])
    List.replace_at(state2, birth_period, Enum.at(state2, birth_period) + birthing)
  end

  def step_n_days(initial_state, n_days, birth_period \\ 6) do
    Enum.reduce(1..n_days, initial_state, fn _, s -> step_day(s, birth_period) end)
  end

  def how_many(state) do
    Enum.sum(state)
  end


  def run_a do
    data = read_data("day6_input.txt")

    initial_state = instances_to_counts(data)
    state = step_n_days(initial_state, 80)
    IO.puts(how_many(state))
  end

  def run_b do
    data = read_data("day6_input.txt")

    initial_state = instances_to_counts(data)
    state = step_n_days(initial_state, 256)
    IO.puts(how_many(state))
  end

end

Day6.run_a()
Day6.run_b()
