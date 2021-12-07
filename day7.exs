#! /usr/bin/env elixir

defmodule Day7 do

  defp read_data(fname) do
    {:ok, contents} = File.read(fname)
    contents
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end


  defp linear_cost_for_pos(subs, pos) do
    Enum.reduce(subs, 0, &(&2 + abs(&1-pos)))
  end

  defp sum_of_integers(n) do
    div(n*(n+1), 2)
  end

  defp sum_cost_for_pos(subs, pos) do
    Enum.reduce(subs, 0, &(&2 + sum_of_integers(abs(&1-pos))))
  end

  defp search(pos, cost, subs, cost_fun) do
    next_cost = cost_fun.(subs, pos+1)
    gradient = next_cost - cost
    if gradient > 0 do
      cost #if the gradient is positive, we're at the minimum and can stop
    else
      search(pos+1, next_cost, subs, cost_fun)
    end
  end

  defp scan(subs, cost_fun) do
    # we scan from position 0 and up, stopping when the cost gradient turns positive.
    # the assumption made here is that all subs are at non-negative position,
    # so that position 0 has no subs on the left side
    pos0_cost = cost_fun.(subs, 0)
    search(0, pos0_cost, subs, cost_fun)
  end

  def run_a do
    data = read_data("day7_input.txt")
    lowest_cost = scan(data, &linear_cost_for_pos/2)
    IO.puts(lowest_cost)
  end

  def run_b do
    data = read_data("day7_input.txt")
    lowest_cost = scan(data, &sum_cost_for_pos/2)
    IO.puts(lowest_cost)
  end

end

Day7.run_a()
Day7.run_b()
