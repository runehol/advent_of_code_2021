#! /usr/bin/env elixir
defmodule Parallel do
  def map(collection, function) do
    collection
    |> Enum.map(&Task.async(fn -> function.(&1) end))
    |> Enum.map(&Task.await(&1))
  end
end


defmodule Day19 do
  defp parse_probes(probes) do
    for line <- probes, into: MapSet.new, do: line |>
    String.split(",") |>
    Enum.map(&String.to_integer/1) |>
    List.to_tuple
  end

  defp read_data(fname) do
    {:ok, contents} = File.read(fname)

    contents
    |> String.split("\n", trim: true)
    |> Enum.chunk_by(&(String.starts_with?(&1, "--- scanner")))
    |> Enum.drop_every(2)
    |> Enum.map(&parse_probes/1)

  end

  defp rotate({x, y, z},  0), do: { x,  y,  z}
  defp rotate({x, y, z},  1), do: { x,  z, -y}
  defp rotate({x, y, z},  2), do: { x, -z,  y}
  defp rotate({x, y, z},  3), do: { x, -y, -z}

  defp rotate({x, y, z},  4), do: { y,  x, -z}
  defp rotate({x, y, z},  5), do: { y,  z,  x}
  defp rotate({x, y, z},  6), do: { y, -z, -x}
  defp rotate({x, y, z},  7), do: { y, -x,  z}

  defp rotate({x, y, z},  8), do: { z,  x,  y}
  defp rotate({x, y, z},  9), do: { z,  y, -x}
  defp rotate({x, y, z}, 10), do: { z, -y,  x}
  defp rotate({x, y, z}, 11), do: { z, -x, -y}

  defp rotate({x, y, z}, 12), do: {-z,  x, -y}
  defp rotate({x, y, z}, 13), do: {-z,  y,  x}
  defp rotate({x, y, z}, 14), do: {-z, -y, -x}
  defp rotate({x, y, z}, 15), do: {-z, -x,  y}

  defp rotate({x, y, z}, 16), do: {-y,  x,  z}
  defp rotate({x, y, z}, 17), do: {-y,  z, -x}
  defp rotate({x, y, z}, 18), do: {-y, -z,  x}
  defp rotate({x, y, z}, 19), do: {-y, -x, -z}

  defp rotate({x, y, z}, 20), do: {-x,  y, -z}
  defp rotate({x, y, z}, 21), do: {-x,  z,  y}
  defp rotate({x, y, z}, 22), do: {-x, -z, -y}
  defp rotate({x, y, z}, 23), do: {-x, -y,  z}

  defp rotate_set(rot, s) do
    for p <- s, into: MapSet.new, do: rotate(p, rot)
  end

  defp translate({x, y, z}, {tx, ty, tz}), do: {x+tx, y+ty, z+tz}

  defp translate_set(tr, s) do
    for p <- s, into: MapSet.new, do: translate(p, tr)
  end

  defp sub({x2, y2, z2}, {x1, y1, z1}), do: {x2-x1, y2-y1, z2-z1}


  def best_translation(a_set, b_set, rot) do
    Enum.reduce(a_set, %{}, fn a, d ->
      Enum.reduce(b_set, d, fn b, d ->
        pos = sub(a, b)
        Map.update(d, pos, 1, &(&1+1))
      end)
    end)
    |> Enum.map(fn {pos, corr} -> {corr, rot, pos} end)
    |> Enum.max
  end

  defp correlate(established_set, new_set) do
    {corr, rot, pos} = Parallel.map(0..23, fn rot ->
      rot_new_set = rotate_set(rot, new_set)
      best_translation(established_set, rot_new_set, rot)
    end)
    |> Enum.max

    {corr, translate_set(pos, rotate_set(rot, new_set)), rot, pos}
  end

  defp add_to_accepted_set(new_set, {accepted, rejected}) do
    {correlations, tr_rot_set, _, pos} =
      Enum.reduce(accepted, {0, MapSet.new, -1, {0, 0, 0}},
      fn {existing_set, _}, acc ->
        if elem(acc, 0) >= 12 do
          acc
        else
          max(correlate(existing_set, new_set), acc)
        end
      end)
    if correlations >= 12 do
      {[{tr_rot_set, pos}|accepted], rejected}
    else
      {accepted, [new_set|rejected]}
    end
  end


  defp build_map_step(accepted, not_accepted) do
    {new_accepted, new_rejected} = not_accepted
    |> Enum.reduce({accepted, []}, &add_to_accepted_set/2)
    if new_rejected != [] do
      build_map_step(new_accepted, new_rejected)
    else
      new_accepted
    end
  end

  defp manhattan_distance({x2, y2, z2}, {x1, y1, z1}), do: abs(x2-x1) + abs(y2-y1) + abs(z2-z1)

  defp largest_distance(all_sets) do
    positions = Enum.map(all_sets, fn {_, pos} -> pos end)
    all_distances = for p1 <- positions, p2 <- positions, do: manhattan_distance(p1, p2)
    Enum.max(all_distances)
  end

  defp build_map(data) do
    all_sets = build_map_step([{Enum.at(data, 0), {0, 0, 0}}], Enum.drop(data, 1))
    map = Enum.reduce(all_sets, MapSet.new, fn {new, _}, val -> MapSet.union(new, val) end)
    size = MapSet.size(map)
    max_distance = largest_distance(all_sets)
    {map, size, max_distance}
  end

  def run_ab do
    data = read_data("day19_input.txt")

    {_, size, max_distance} = build_map(data)
    IO.inspect({size, max_distance})
  end




end

Day19.run_ab()
