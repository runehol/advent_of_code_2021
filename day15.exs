#! /usr/bin/env elixir

defmodule Day15 do
  @infinity 999999999999


  defp read_data(fname) do
    {:ok, contents} = File.read(fname)
    elements = contents
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)

    map = elements
    |> Enum.with_index(fn elements, y -> Enum.with_index(elements, &({{y, &2}, &1-?0})) end)
    |> Enum.concat
    |> Map.new

    sizes = {length(elements), length(hd(elements))}
    {sizes, map}
  end

  defp neighbours({y, x}) do
    [{y, x-1}, {y, x+1}, {y-1, x}, {y+1, x}]
  end

  defp get_or_inf(m, key) do
    Map.get(m, key, @infinity)
  end

  defp lowest_score(open_set) do
    {k, _} = open_set
    |> Enum.reduce({"?", @infinity}, fn {k, v}, {bestk, bestv} ->
      if v <= bestv do
        {k, v}
      else
        {bestk, bestv}
      end
    end)
    k
  end



  defp astar_loop(goal, costs, h, open_set, g_score, f_score, came_from) do
    if map_size(open_set) == 0 do
      @infinity # failure
    else
      current = lowest_score(open_set)
      if current == goal do
        get_or_inf(f_score, current)
      else
        open_set = Map.delete(open_set, current)
        g_score_current = get_or_inf(g_score, current)
        {open_set, g_score, f_score, came_from} = Enum.reduce(neighbours(current), {open_set, g_score, f_score, came_from},
        fn neighbour, {open_set, g_score, f_score, came_from} ->
           cost = get_or_inf(costs, neighbour)
           if cost == @infinity do
            {open_set, g_score, f_score, came_from}
           else
            tentative_g_score = g_score_current + cost
            if tentative_g_score < get_or_inf(g_score, neighbour) do
              came_from = Map.put(came_from, neighbour, current)
              g_score = Map.put(g_score, neighbour, tentative_g_score)
              new_f = tentative_g_score + h.(neighbour)
              f_score = Map.put(f_score, neighbour, new_f)
              open_set = Map.update(open_set, neighbour, new_f, &(min(&1, new_f)))
              {open_set, g_score, f_score, came_from}
            else
              {open_set, g_score, f_score, came_from}
            end
           end
        end)
        astar_loop(goal, costs, h, open_set, g_score, f_score, came_from)
      end
    end
  end



  defp astar(start, goal, costs) do

    h = fn({y, x}) ->
      {gy, gx} = goal
      abs(gx-x) + abs(gy-y)
    end
    g_score = %{ start => 0}
    came_from = %{}
    f_score = %{ start => h.(start)}
    open_set = %{ start => get_or_inf(f_score, start)}
    astar_loop(goal, costs, h, open_set, g_score, f_score, came_from)
  end

  defp wrap(val) do
    if val > 9, do: wrap(val - 9), else: val
  end

  defp repeat_map({sizes, map}, repeats) do
    {oh, ow} = sizes
    {nh, nw} = {oh*repeats, ow*repeats}

    new_map = for y <- 0..nh-1, x <- 0..nw-1, into: %{}, do: {{y, x}, wrap(Map.get(map, {rem(y, oh), rem(x, ow)}) + div(y, oh) + div(x, ow))}
    {{nh, nw}, new_map}
  end

  def run_a do
    {sizes, map} = read_data("day15_input.txt")
    {h, w} = sizes


    res = astar({0, 0}, {h-1, w-1}, map)
    IO.puts(res)
  end

  def run_b do
    {sizes, map} = read_data("day15_input.txt") |> repeat_map(5)
    {h, w} = sizes
    res = astar({0, 0}, {h-1, w-1}, map)
    IO.puts(res)

  end

end

Day15.run_a()
Day15.run_b()
