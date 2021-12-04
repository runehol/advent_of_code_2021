
defmodule AdventOfCode do
  @moduledoc """
  Documentation for `AdventOfCode`.
  """

  def transpose(data) do
    data
    |> Stream.zip
    |> Stream.map(&Tuple.to_list/1)
  end

  def parse_contents(contents) do
    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&to_charlist/1)
    |> Enum.map(fn(lst) -> (Enum.map(lst, &(&1 - 48))) end)
    |> transpose()
  end

  def read_data(fname) do
    case File.read(fname) do
      {:ok, contents} -> contents |> parse_contents()
      end
  end

  def most_common(lst) do
    if Enum.sum(lst) >= length(lst)/2 do
      1
    else
      0
    end
  end

  def bit_list_to_integer(lst) do
    lst
    |> Enum.map(&(&1 + 48))
    |> List.to_integer(2)
  end



  def day3_a do
    data = read_data("day3_input.txt")
    most_common_bits = data
      |> Enum.map(&most_common/1)

    least_common_bits = most_common_bits
      |> Enum.map(&(1 - &1))
    gamma = bit_list_to_integer(most_common_bits)
    epsilon = bit_list_to_integer(least_common_bits)
    gamma_epsilon = gamma * epsilon
    IO.puts(gamma_epsilon)

  end
end
