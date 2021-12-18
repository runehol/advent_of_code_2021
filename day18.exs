#! /usr/bin/env elixir
defmodule Day18 do

  defp read_data(fname) do
    {:ok, contents} = File.read(fname)
    contents
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      elem(Code.eval_string(line), 0)
    end)
  end

  def max_depth([left, right], depth) do
    max(max_depth(left, depth+1), max_depth(right, depth+1))
  end

  def max_depth(num, depth) when is_number(num) do
    depth
  end

  def max_depth(v) do
    max_depth(v, 0)
  end

  def has_10_or_more([left, right]) do
    has_10_or_more(left) || has_10_or_more(right)
  end
  def has_10_or_more(num) when is_number(num) do
    num >= 10
  end

  def perform_split_action(v, :done) do
    {v, :done}
  end

  def perform_split_action(num, :split_leftmost) when is_number(num) do
    if num >= 10 do
      {[div(num, 2), div(num+1, 2)], :done}
    else
      {num, :split_leftmost}
    end
  end

  def perform_split_action([left, right], :split_leftmost) do
    {left_res, next_action} = perform_split_action(left, :split_leftmost)
    {right_res, next_action2} = perform_split_action(right, next_action)
    {[left_res, right_res], next_action2}
  end



  def replace_exploding_pair(num, pos, _) when is_number(num) do
    {num, pos+1, []}
  end

  def replace_exploding_pair([a, b], pos, depth) when depth == 4 do
    {0, pos+1, [{pos-1, a}, {pos+1, b}]}
  end

  def replace_exploding_pair([left, right], pos, depth) do
    {left_res, pos_after_left, actions_after_left} = replace_exploding_pair(left, pos, depth+1)
    if actions_after_left != [] do
      #already found the pair, we can cut short the search
      {[left_res, right], pos_after_left, actions_after_left}
    else
      {right_res, pos_after_right, actions_after_right} = replace_exploding_pair(right, pos_after_left, depth+1)
      {[left_res, right_res], pos_after_right, actions_after_right}
    end
  end


  def perform_adds(num, pos, [{act_pos, num_to_add}|rest_actions]) when is_number(num) do
    if pos == act_pos do
      {num+num_to_add, pos+1, rest_actions}
    else
      {num, pos+1, [{act_pos, num_to_add}|rest_actions]}
    end
  end


  def perform_adds(v, pos, [{act_pos, _}|rest_actions]) when pos > act_pos do
    perform_adds(v, pos, rest_actions)
  end

  def perform_adds(v, pos, []) do
    {v, pos, []} # we're done, don't care about counting positions anymore
  end

  def perform_adds([left, right], pos, actions) do
    {left_res, pos_after_left, actions_after_left} = perform_adds(left, pos, actions)
    {right_res, pos_after_right, actions_after_right} = perform_adds(right, pos_after_left, actions_after_left)
    {[left_res, right_res], pos_after_right, actions_after_right}
  end


  def explode(expr) do
    {expr_after_replace, _, actions_after_replace} = replace_exploding_pair(expr, 0, 0)
    {expr_after_adds, _, _} = perform_adds(expr_after_replace, 0, actions_after_replace)
    expr_after_adds
  end

  def split(expr) do
    {res, _} = perform_split_action(expr, :split_leftmost)
    res
  end


  def reduce(expr) do
    cond do
      max_depth(expr) >= 5 -> reduce(explode(expr))
      has_10_or_more(expr) -> reduce(split(expr))
      true -> expr
    end
  end



  def magnitude(num) when is_number(num) do
    num
  end

  def magnitude([left, right]) do
    3* magnitude(left) + 2 * magnitude(right)
  end

  def add(left, right) do
    [left, right]
  end
  def run_a do
    data = read_data("day18_input.txt")

    data
    |> Enum.reduce(fn next, prev ->
      reduce(add(prev, next))
    end)
    |> magnitude()
    |> IO.puts()
  end

  def sum(a, b) do
    magnitude(reduce(add(a, b)))
  end

  def run_b do
    data = read_data("day18_input.txt")

    data |>
    Enum.flat_map(fn a ->
      Enum.map(data, fn b ->
        max(sum(a, b), sum(b, a))
      end)
    end)
    |> Enum.max()
    |> IO.inspect()
  end

end

Day18.run_a()
Day18.run_b()
