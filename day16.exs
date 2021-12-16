#! /usr/bin/env elixir
defmodule Day16 do



  defp read_data(fname) do
    {:ok, contents} = File.read(fname)
    Base.decode16!(String.trim(contents))

  end

  defp parse_literal(<<0::1, value::4, rest::bitstring>>, value_so_far) do
    {value_so_far*16 + value, rest}
  end

  defp parse_literal(<<1::1, value::4, rest::bitstring>>, value_so_far) do
    parse_literal(rest, value_so_far*16 + value)
  end

  defp parse_operator(0) do :sum end
  defp parse_operator(1) do :product end
  defp parse_operator(2) do :minimum end
  defp parse_operator(3) do :maximum end
  defp parse_operator(5) do :greater_than end
  defp parse_operator(6) do :less_than end
  defp parse_operator(7) do :equal_to end

  # type = 4: literal
  defp parse_packet(<<version::3, 4::3, body::bitstring>>) do
    {literal, rest} = parse_literal(body, 0)
    {{:literal, version, literal}, rest}
  end

  # other types: operators
  defp parse_packet(<<version::3, type::3, 0::1, length_in_bits::15, body::bitstring>>) do
    {sub_packets, rest} = parse_subpackets_by_bits(bit_size(body) - length_in_bits, body)
    {{:operator, version, parse_operator(type), sub_packets}, rest}
  end

  defp parse_packet(<<version::3, type::3, 1::1, n_subpackets::11, body::bitstring>>) do
    {sub_packets, rest} = parse_subpackets_by_count(n_subpackets, body)
    {{:operator, version, parse_operator(type), sub_packets}, rest}
  end

  defp parse_subpackets_by_count(0, rest) do
    {[], rest}
  end

  defp parse_subpackets_by_count(n, body) do
    {p, rest} = parse_packet(body)
    {other_packets, rest1} = parse_subpackets_by_count(n-1, rest)
    {[p|other_packets], rest1}
  end

  defp parse_subpackets_by_bits(parse_until_size, body) do
    bits = bit_size(body) - parse_until_size
    if bits < 0, do: raise "negative bit count in subpackets"

    if bits == 0 do
        {[], body}
    else
      {p, rest} = parse_packet(body)
      {other_packets, rest1} = parse_subpackets_by_bits(parse_until_size, rest)
      {[p|other_packets], rest1}
    end
  end



  defp sum_version_numbers({:literal, version, _}) do
    version
  end

  defp sum_version_numbers({:operator, version, _, sub_packets}) do
    version +
    (sub_packets
    |> Enum.map(&sum_version_numbers/1)
    |> Enum.sum)
  end

  def run_a do
    data = read_data("day16_input.txt")
    {packet, _} = parse_packet(data)
    IO.puts(sum_version_numbers(packet))
  end

  defp boolean_to_integer(bool) do
    if bool, do: 1, else: 0
  end

  defp eval_packet({:literal, _, v}) do
    v
  end

  defp eval_packet({:operator, _, :sum, sub_packets}) do
    sub_packets |> Enum.map(&eval_packet/1) |> Enum.sum
  end

  defp eval_packet({:operator, _, :product, sub_packets}) do
    sub_packets |> Enum.map(&eval_packet/1) |> Enum.product
  end

  defp eval_packet({:operator, _, :minimum, sub_packets}) do
    sub_packets |> Enum.map(&eval_packet/1) |> Enum.min
  end

  defp eval_packet({:operator, _, :maximum, sub_packets}) do
    sub_packets |> Enum.map(&eval_packet/1) |> Enum.max
  end

  defp eval_packet({:operator, _, :greater_than, sub_packets}) do
    [a, b] = sub_packets |> Enum.map(&eval_packet/1)
    boolean_to_integer(a > b)
  end

  defp eval_packet({:operator, _, :less_than, sub_packets}) do
    [a, b] = sub_packets |> Enum.map(&eval_packet/1)
    boolean_to_integer(a < b)
  end

  defp eval_packet({:operator, _, :equal_to, sub_packets}) do
    [a, b] = sub_packets |> Enum.map(&eval_packet/1)
    boolean_to_integer(a == b)
  end


  def run_b do
    data = read_data("day16_input.txt")
    {packet, _} = parse_packet(data)
    IO.puts(eval_packet(packet))
  end

end

Day16.run_a()
Day16.run_b()
