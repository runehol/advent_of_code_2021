#! /usr/bin/env elixir


defmodule Day24PrologGen do

  @nop {:nop, []}

  defp simplify_prev_with_curr(_, {:mul, [v, 0]}), do: {:mov, [v, 0]}
  defp simplify_prev_with_curr(_, {:div, [_, 1]}), do: @nop
  defp simplify_prev_with_curr(_, {:add, [_, 0]}), do: @nop
  defp simplify_prev_with_curr({:mul, [v, 0]}, {:add, [v, v2]}), do: {:mov, [v, v2]}

  defp simplify_prev_with_curr(_, instr), do: instr


  defp simplify_curr_with_next({:mov, [v, 0]}, {:mov, [v, _]}), do: @nop
  defp simplify_curr_with_next(instr, _), do: instr

  defp parse_operand(v) do
    try do
      String.to_integer(v)
    rescue
      ArgumentError -> case v do
        "x" -> :X
        "y" -> :Y
        "z" -> :Z
        "w" -> :W
      end
    end
  end

  def read_file(fname) do
    instructions = File.stream!(fname)
    |> Stream.reject(&(&1 == ""))
    |> Stream.map(fn line ->
      line = String.trim(line)
      [op_str|operands] = String.split(line, " ")
      op = case op_str do
        "mul" -> :mul
        "add" -> :add
        "inp" -> :inp
        "div" -> :div
        "mod" -> :mod
        "eql" -> :eql
      end
      operands = Enum.map(operands, &parse_operand/1)
      {op, operands}
    end)

    instructions =
    Stream.zip(Stream.concat([@nop], instructions), instructions)
    |> Stream.map(fn {prev, curr} -> simplify_prev_with_curr(prev, curr) end)
    |> Enum.reject(&(&1 == @nop))


    instructions =
      Stream.zip(instructions, Stream.concat(Stream.drop(instructions, 1), [@nop]))
      |> Stream.map(fn {curr, next} -> simplify_curr_with_next(curr, next) end)
      |> Enum.reject(&(&1 == @nop))
    instructions
  end

  def codegen_prelude(f) do
    IO.puts(f, ":- use_module(library(clpfd)).")
    IO.puts(f, "")
    IO.puts(f, "problem(D) :-")

    Stream.map(0..13, fn idx ->
      IO.puts(f, "    D#{idx} in 1..9,")
    end)
    |> Stream.run()

    IO.puts(f, "    Z0 #= 0,")



  end

  def src_operand(v, _) when is_integer(v), do: "#{v}"
  def src_operand(v, numbering) when is_atom(v), do: "#{v}#{numbering[v]}"

  def dest_operand(v, numbering) do
    numbering2 = Map.update!(numbering, v, &(&1 + 1))
    {"#{v}#{numbering2[v]}", numbering2}
  end

  def opcode(:add), do: "+"
  def opcode(:mul), do: "*"
  def opcode(:div), do: "div"
  def opcode(:mod), do: "rem"



  def codegen_instruction(f, {:mov, [dest, src]}, numbering) do
    {dest, numbering2} = dest_operand(dest, numbering)
    IO.puts(f, "    #{dest} #= #{src_operand(src, numbering)},")
    numbering2
  end

  def codegen_instruction(f, {:eql, [dest_src1, src2]}, numbering) do
    {dest, numbering2} = dest_operand(dest_src1, numbering)
    IO.puts(f, "    #{dest} #<==>  #{src_operand(dest_src1, numbering)} #= #{src_operand(src2, numbering)},")
    numbering2
  end


  def codegen_instruction(f, {op, [dest_src1, src2]}, numbering) do
    {dest, numbering2} = dest_operand(dest_src1, numbering)
    IO.puts(f, "    #{dest} #= #{src_operand(dest_src1, numbering)} #{opcode(op)} #{src_operand(src2, numbering)},")
    numbering2
  end

  def codegen_instruction(f, {:inp, [dest]}, numbering) do
    {dest, numbering2} = dest_operand(dest, numbering)
    {src, numbering3} = dest_operand(:D, numbering2)
    IO.puts(f, "    #{dest} #= #{src},")
    numbering3
  end

  def codegen_postlude(f, numbering) do
    src = src_operand(:Z, numbering)
    IO.puts(f, "    #{src} #= 0,")
    IO.puts(f, ["    D #= ", Enum.map(0..13, fn idx -> "D#{idx} * #{Integer.pow(10, 13-idx)}" end)
    |> Enum.join(" * "), "."])

  end

  def run do
      instructions = read_file("day24_input.txt")
      #IO.inspect(instructions)
      f = File.open!("day24.pl", [:write, :utf8])
      codegen_prelude(f)
      initial_numbering = %{X: 0, Y: 0, Z: 0, W: 0, D: -1}
      numbering = Enum.reduce(instructions, initial_numbering, fn instr, numbering ->
        codegen_instruction(f, instr, numbering)
      end)
      codegen_postlude(f, numbering)

      File.close(f)

  end




end

Day24PrologGen.run()
