#! /usr/bin/env elixir

defmodule Day1 do

  defp read_data(fname) do
    File.stream!(fname)
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end


  def run_a do
    numbers = read_data("day1_input.txt")

    Stream.zip(numbers, tl(numbers))
    |> Stream.map(fn {a, b} -> if b > a, do: 1, else: 0 end)
    |> Enum.sum
    |> IO.puts
  end

  def sum3(lst) do
    Enum.zip(lst, tl(lst))
    |> Enum.zip(tl(tl(lst)))
    |> Enum.map(fn {{a,b}, c} -> a+b+c end)
  end

  def run_b do
    numbers = read_data("day1_input.txt")
    sums = sum3(numbers)

    Stream.zip(sums, tl(sums))
    |> Stream.map(fn {a, b} -> if b > a, do: 1, else: 0 end)
    |> Enum.sum
    |> IO.puts
  end



end

Day1.run_a()
Day1.run_b()
