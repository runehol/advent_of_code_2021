#! /usr/bin/env elixir

defmodule Day8 do

  defp parse_digits(line) do
    line
    |> String.split(" ", trim: true)
    |> Enum.map(&(MapSet.new(String.to_charlist(&1))))
  end

  defp parse_line(line) do
    line
    |> String.split("|", trim: true)
    |> Enum.map(&parse_digits/1)
    |> List.to_tuple
  end

  defp read_data(fname) do
    {:ok, contents} = File.read(fname)
    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end


  defp count_1478({_, displayed_digits}) do
    Enum.count(displayed_digits, fn set ->
      n = MapSet.size(set)
      n == 2 || n == 4 || n == 3 || n == 7
    end)
  end

  def run_a do
    data = read_data("day8_input.txt")

    counts = Enum.reduce(data, 0, &(&2 + count_1478(&1)))
    IO.puts(counts)
  end

  defp segment_frequencies(all_digits) do
    all_digits
    |> Enum.flat_map(&MapSet.to_list/1)
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end

  defp solve_digits({all_digits, displayed_digits}) do
    one = Enum.find(all_digits, &(MapSet.size(&1) == 2))
    four = Enum.find(all_digits, &(MapSet.size(&1) == 4))
    seven = Enum.find(all_digits, &(MapSet.size(&1) == 3))
    eight = Enum.find(all_digits, &(MapSet.size(&1) == 7))
    segment_freqs = segment_frequencies(all_digits)

    {b,_} = Enum.find(segment_freqs, fn {_, count} -> count == 6 end)
    {e,_} = Enum.find(segment_freqs, fn {_, count} -> count == 4 end)

    five = Enum.find(all_digits, &(MapSet.size(&1) == 5 && MapSet.member?(&1, b)))

    d = MapSet.difference(four, one)
    |> MapSet.to_list
    |> Enum.find(&(&1 != b))

    zero = Enum.find(all_digits, &(MapSet.size(&1) == 6 && !MapSet.member?(&1, d)))

    two = Enum.find(all_digits, &(MapSet.size(&1) == 5 && MapSet.member?(&1, e)))

    three = Enum.find(all_digits, &(MapSet.size(&1) == 5 && &1 != two && &1 != five))
    nine = Enum.find(all_digits, &(MapSet.size(&1) == 6 && !MapSet.member?(&1, e)))
    six = Enum.find(all_digits, &(MapSet.size(&1) == 6 && &1 != nine && &1 != zero))


    translation = %{
      zero => ?0,
      one => ?1,
      two => ?2,
      three => ?3,
      four => ?4,
      five => ?5,
      six => ?6,
      seven => ?7,
      eight => ?8,
      nine => ?9,
    }
    displayed_digits
    |> Enum.map(&(Map.get(translation, &1)))
    |> List.to_integer(10)
  end



  def run_b do
    data = read_data("day8_input.txt")

    data
    |> Enum.map(&solve_digits/1)
    |> Enum.sum
    |> IO.puts
  end

end

Day8.run_a()
Day8.run_b()
