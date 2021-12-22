#! /usr/bin/env elixir
defmodule OctreeNode do
  defstruct [split_point: [0, 0, 0], children: [:off, :off, :off, :off, :off, :off, :off, :off]]

  def new(split_point, atom) when is_atom(atom) do
    %OctreeNode{split_point: split_point, children: [atom, atom, atom, atom, atom, atom, atom, atom]}
  end
end

defmodule Octree do
  @neginfinity -10000000000
  @posinfinity +10000000000


  def new(atom) when is_atom(atom) do
    atom
  end

  def clip_position_against_bounds(pos, {lower_bound, upper_bound}) do
    pos
    |> Enum.zip_with(lower_bound, &max/2)
    |> Enum.zip_with(upper_bound, &min/2)
  end

  def clip_box_against_bounds({lower_box, upper_box}, bounds) do
    {clip_position_against_bounds(lower_box, bounds), clip_position_against_bounds(upper_box, bounds)}
  end

  def size_of_box({lower_box, upper_box}) do
    Enum.zip_with(upper_box, lower_box, &(max(&1 - &2, 0)))
    |> Enum.product
  end

  def clip_box({lower, upper}) do
    {
      Enum.zip_with(lower, upper, &min/2),
      Enum.zip_with(lower, upper, &max/2)
    }
  end
  def child_bounds([sx, sy, sz], {[lx, ly, lz], [ux, uy, uz]}) do
    [
      clip_box({[lx, ly, lz], [sx, sy, sz]}),
      clip_box({[lx, ly, sz], [sx, sy, uz]}),
      clip_box({[lx, sy, lz], [sx, uy, sz]}),
      clip_box({[lx, sy, sz], [sx, uy, uz]}),
      clip_box({[sx, ly, lz], [ux, sy, sz]}),
      clip_box({[sx, ly, sz], [ux, sy, uz]}),
      clip_box({[sx, sy, lz], [ux, uy, sz]}),
      clip_box({[sx, sy, sz], [ux, uy, uz]}),
    ]
  end

  def insert(tree, _, _, {[l, _, _], [u, _, _]}) when l >= u, do: tree #inserting into zero-extent bounds
  def insert(tree, _, _, {[_, l, _], [_, u, _]}) when l >= u, do: tree #inserting into zero-extent bounds
  def insert(tree, _, _, {[_, _, l], [_, _, u]}) when l >= u, do: tree #inserting into zero-extent bounds

  def insert(atom, box, value, {lower_bound, upper_bound}=bounds) when is_atom(atom) do
    {lower_box, upper_box} = clip_box_against_bounds(box, bounds)
    cond do
      size_of_box({lower_box, upper_box}) == 0 -> atom
      Enum.zip_with(lower_box, lower_bound, &(&1 - &2)) |> Enum.max > 0 -> insert(OctreeNode.new(lower_box, atom), {lower_box, upper_box}, value, bounds)
      Enum.zip_with(upper_bound, upper_box, &(&1 - &2)) |> Enum.max > 0 -> insert(OctreeNode.new(upper_box, atom), {lower_box, upper_box}, value, bounds)
      true -> value
    end

  end


  def insert(%OctreeNode{split_point: split_point, children: children}=tree, box, value, bounds) do
    box = clip_box_against_bounds(box, bounds)
    if size_of_box(box) == 0 do
      tree
    else
      %OctreeNode{
        split_point: split_point,
        children: Enum.zip_with(children, child_bounds(split_point, bounds), fn child, b ->
          insert(child, box, value, b)
        end)}
    end
  end


  def insert(tree, box, value) do
    insert(tree, box, value, {[@neginfinity, @neginfinity, @neginfinity], [@posinfinity, @posinfinity, @posinfinity]})
  end

  def reduce(atom, acc, reducer, bounds) when is_atom(atom) do
    reducer.({bounds, atom}, acc)
  end

  def reduce(%OctreeNode{split_point: split_point, children: children}, acc, reducer, bounds) do
    Enum.zip_with(children, child_bounds(split_point, bounds), &({&1, &2}))
    |> Enum.reduce(acc, fn {child, b}, acc ->
      reduce(child, acc, reducer, b)
    end)
  end


  def reduce(tree, acc, reducer) do
    reduce(tree, acc, reducer, {[@neginfinity, @neginfinity, @neginfinity], [@posinfinity, @posinfinity, @posinfinity]})
  end
end


defmodule Day22 do

  defp read_data(fname) do
    {:ok, contents} = File.read(fname)
    contents
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [_, onoff, xmin, xmax, ymin, ymax, zmin, zmax] = Regex.run(~r/(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)/, line)
      value = if onoff == "on" do
        :on
      else
        :off
      end
      {
        { [String.to_integer(xmin), String.to_integer(ymin), String.to_integer(zmin)],
          [String.to_integer(xmax)+1, String.to_integer(ymax)+1, String.to_integer(zmax)+1]},
        value
      }
    end)
  end

  def count_on({bounds, :on}, acc) do
    Octree.size_of_box(bounds) + acc
  end

  def count_on({_, :off}, acc) do
    acc
  end

  def count_on_clipped({obounds, :on}, acc) do
    bounds = Octree.clip_box_against_bounds(obounds, {[-50,-50,-50],[51,51,51]})
    Octree.size_of_box(bounds) + acc
  end

  def count_on_clipped({_, :off}, acc) do
    acc
  end

  def run_ab do
    commands = read_data("day22_input.txt")

    tree = Enum.reduce(commands, Octree.new(:off), fn {box, value}, tree ->
      Octree.insert(tree, box, value)
    end)

    IO.inspect(Octree.reduce(tree, 0, &count_on_clipped/2))
    IO.inspect(Octree.reduce(tree, 0, &count_on/2))
  end


end

Day22.run_ab()
