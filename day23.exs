#! /usr/bin/env elixir



defmodule Day23 do
  use Memoize
  @infinity 999999999999


  def print_map(map, {xmax, ymax}) do
    data = [
      ["+", String.duplicate("+", xmax+1), "+\n"],
      ["+", Enum.map(0..xmax, &(Map.get(map, {&1,0}, "."))), "+\n"],
      Enum.map(1..ymax, fn y ->
        ["+++", Enum.map(2..xmax-1, &(Map.get(map, {&1,y}, (if rem(&1, 2) == 0, do: ".", else: "+")))), "++\n"]
      end),
      ["+", String.duplicate("+", xmax+1), "+\n"]]
    IO.puts(data)
  end

  defp move_cost("A"), do: 1
  defp move_cost("B"), do: 10
  defp move_cost("C"), do: 100
  defp move_cost("D"), do: 1000

  defp preferred_burrow("A"), do: 2
  defp preferred_burrow("B"), do: 4
  defp preferred_burrow("C"), do: 6
  defp preferred_burrow("D"), do: 8

  defp direction({_, y}, _) when y > 0, do: :upleftright # out of the burrow
  defp direction({x, 0}, preferred_x) when preferred_x < x, do: :leftdown
  defp direction({x, 0}, preferred_x) when preferred_x > x, do: :rightdown

  defp correct_pos({2, y}, "A") when y > 0, do: true
  defp correct_pos({4, y}, "B") when y > 0, do: true
  defp correct_pos({6, y}, "C") when y > 0, do: true
  defp correct_pos({8, y}, "D") when y > 0, do: true
  defp correct_pos({_, y}, "P") when y > 0, do: true
  defp correct_pos(_, _), do: false

  defp legal_stopping_point({2, 0}, _), do: false
  defp legal_stopping_point({4, 0}, _), do: false
  defp legal_stopping_point({6, 0}, _), do: false
  defp legal_stopping_point({8, 0}, _), do: false
  defp legal_stopping_point({_, 0}, :leftdown), do: false
  defp legal_stopping_point({_, 0}, :rightdown), do: false
  defp legal_stopping_point({_, 0}, :down), do: false
  defp legal_stopping_point(_, :upleftright), do: false
  defp legal_stopping_point(_, _), do: true

  defp step({x, y}, :upleftright), do: {x, y-1}
  defp step({x, 0}, :left), do: {x-1, 0}
  defp step({x, 0}, :right), do: {x+1, 0}
  defp step({x, 0}, :leftdown), do: {x-1, 0}
  defp step({x, 0}, :rightdown), do: {x+1, 0}
  defp step({x, y}, :down), do: {x, y+1}

  defp next_moves({_, 0}, _, :upleftright), do: [:left, :right]
  defp next_moves({x, 0}, x, :leftdown), do: [:down]
  defp next_moves({x, 0}, x, :rightdown), do: [:down]
  defp next_moves(_, _, dir), do: [dir]

  defp blocked_board(map, {_, ymax}) do
    Enum.reduce(["A", "B", "C", "D"], false, fn kind, blocked ->
      if blocked do
        true
      else
        x = preferred_burrow(kind)
        {_, seen_blocked} = Enum.reduce(1..ymax, {false, false}, fn y, {seen_parked, seen_blocked} ->
          value = Map.get(map, {x, y}, ".")
          case value do
            "P"   -> {true, seen_blocked}
            ^kind -> {seen_parked, seen_blocked}
            _     -> {seen_parked, seen_parked||seen_blocked}
          end
        end)
        seen_blocked
      end
    end)
  end

  defp min_moves({a_cost, a_moves}, {b_cost, b_moves}) do
    if a_cost <= b_cost do
      {a_cost, a_moves}
    else
      {b_cost, b_moves}
    end
  end

  defp move_piece(map, from_pos, {x, y}=pos, kind, dir_to_here, {xmax, ymax}=extents, single_move_cost) do
    if x < 0 || x > xmax || y < 0 || y > ymax || Map.has_key?(map, pos) do
      {@infinity, []} # can't do it
    else
      min_move_cost_moves = Enum.reduce(next_moves(pos, preferred_burrow(kind), dir_to_here), {@infinity, []}, fn move, best_cost ->
        next_pos = step(pos, move)
        {cost, moves} = move_piece(map, from_pos, next_pos, kind, move, extents, single_move_cost)
        min_moves(best_cost, {cost+single_move_cost, moves})
      end)

      #if this is a legal stopping point, we should try to stop here and find the next move
      stop_cost_moves = if legal_stopping_point(pos, dir_to_here) do
        stopping_kind = case dir_to_here do
          :down -> "P"
          _ -> kind
        end
        new_map = Map.put(map, pos, stopping_kind)
        if blocked_board(new_map, extents) do
          {@infinity, []}
        else
          {cost, moves} = find_move(new_map, extents)
          {cost, [{from_pos, kind, pos}|moves]}
        end
      else
        {@infinity, []}
      end
      min_moves(min_move_cost_moves, stop_cost_moves)
    end
  end


  defmemo find_move(map, extents) do
    if Enum.reduce(map, true, fn {pos, v}, correct ->
        correct && correct_pos(pos, v)
    end) do
      {0, []}
    else
      # not in all correct positions, we have to try moving them all
      Enum.reduce(map, {@infinity, []}, fn {pos, kind}, best_cost_so_far ->
        if kind == "P" do
          best_cost_so_far
        else
          dir = direction(pos, preferred_burrow(kind))
          next_pos = step(pos, dir)
          single_move_cost = move_cost(kind)
          {cost, moves} = move_piece(Map.delete(map, pos), pos, next_pos, kind, dir, extents, single_move_cost)
          min_moves(best_cost_so_far, {cost+single_move_cost, moves})
        end
      end)
    end
  end

  defp read_data(fname) do
    map = File.read!(fname)
    |> String.split("\n", trim: true)
    |> Enum.drop(1)
    |> Enum.with_index(fn line, y ->
      m = Regex.run(~r/..#([A-D])#([A-D])#([A-D])#([A-D])#.?.?/, line)
      case m do
        [_, p0, p1, p2, p3] -> [{{2, y}, p0}, {{4, y}, p1}, {{6, y}, p2}, {{8, y}, p3}]
        _ -> []
      end
    end)
    |> Enum.concat
    |> Map.new

    ymax = Enum.reduce(map, 0, fn {{_, y}, _}, ym ->
      max(y, ym)
    end)
    {map, {10, ymax}}
  end

  defp print_moves([]), do: nil

  defp print_moves([{{fromx,fromy}, piece, {tox,toy}}|rest]) do
    IO.puts("Move #{piece} from #{fromx},#{fromy} to #{tox},#{toy}")
    print_moves(rest)
  end

  def print_solution({cost, moves}) do
    IO.puts("Cost: #{cost}")
    IO.puts("Moves:")
    print_moves(moves)
    IO.puts("")
  end

  def run_a do
    {map, extents} = read_data("day23_input.txt")
    print_map(map, extents)
    solution = find_move(map, extents)
    print_solution(solution)
  end


  def run_b do
    {map, extents} = read_data("day23_part2_input.txt")
    print_map(map, extents)
    solution = find_move(map, extents)
    print_solution(solution)
  end



end

Day23.run_a()
Day23.run_b()
