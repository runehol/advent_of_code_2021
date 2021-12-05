
defmodule AdventOfCode do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """


  def parse_contents(contents) do
    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&(&1 |> String.to_charlist() |> List.to_tuple()))
  end

  def read_data(fname) do
    case File.read(fname) do
      {:ok, contents} -> contents |> parse_contents()
    end
  end


  def most_common_for_pos(lst, idx) do
    one_count = Enum.count(lst, &(elem(&1, idx) == ?1))
    if one_count >= length(lst)/2, do: ?1, else: ?0
  end

  def most_common(lst) do
    [first | _] = lst
    n_bits = tuple_size(first)
    most_common_as_list =
      for pos <- 0..(n_bits-1) do
        most_common_for_pos(lst, pos)
      end
    most_common_as_list
  end

  def list_to_integer(lst) do
    lst
    |> List.to_integer(2)
  end


  def invert(lst) do
    lst |> Enum.map(&(if &1 == ?0, do: ?1, else: ?0))
  end

  def day3_a do
    data = read_data("day3_input.txt")


    most_common_bits = most_common(data)

    least_common_bits = invert(most_common_bits)
    gamma = list_to_integer(most_common_bits)
    epsilon = list_to_integer(least_common_bits)
    gamma_epsilon = gamma * epsilon
    IO.puts(gamma_epsilon)
  end

end
