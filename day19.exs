#! /usr/bin/env elixir
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

  defp translation_proposals(a_set, b_set) do
    for a <- a_set, b <- b_set, into: MapSet.new, do: sub(a, b)
  end

  defp corr(a, b) do
    MapSet.size(MapSet.intersection(a, b))
  end

  defp correlate(established_set, new_set) do
    Enum.flat_map(0..23, fn rot ->
      rot_new_set = rotate_set(rot, new_set)
      Enum.map(translation_proposals(established_set, rot_new_set), fn tr ->
        tr_new_set = translate_set(tr, rot_new_set)
        {corr(established_set, tr_new_set), tr_new_set, rot, tr}
      end)
    end)
    |> Enum.max
  end

  defp add_to_accepted_set(new_set, {accepted, rejected}) do
    {correlations, tr_rot_set, rot, pos} = Enum.map(accepted, fn {existing_set, _} -> correlate(existing_set, new_set) end) |> Enum.max
    IO.inspect({"Correlation of #{correlations}, rotation #{rot}, position", pos})
    if correlations >= 12 do
      {[{tr_rot_set, pos}|accepted], rejected}
    else
      {accepted, [new_set|rejected]}
    end
  end


  defp build_map_step(accepted, not_accepted) do
    IO.puts("build map step of #{length(accepted)} in, #{length(not_accepted)} out")
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