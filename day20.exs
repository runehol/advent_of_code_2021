#! /usr/bin/env elixir
defmodule Image do
  defstruct image: %{}, default: 0

  def new(img, default \\ 0) do
    %Image{image: img, default: default}
  end

  def sample(%Image{image: img, default: def}, pos) do
    Map.get(img, pos, def)
  end

  def read_lut(%Image{image: img, default: def}, p) do
    Map.get(img, {0, p}, def)
  end

  def neighbours({y, x}) do
    [
      {y-1,x-1},{y-1,x  },{y-1,x+1},
      {y  ,x-1},{y  ,x  },{y  ,x+1},
      {y+1,x-1},{y+1,x  },{y+1,x+1},
    ]
  end

  def sample3x3(img, pos) do
    for p <- neighbours(pos), do: sample(img, p)
  end

  def inclusive_extents(%Image{image: img}) do
    Enum.reduce(img, {1000, -1000, 1000, -1000}, fn {{y,x}, _}, {miny,maxy,minx,maxx} ->
      {min(miny, y), max(maxy, y), min(minx, x), max(maxx, x)}
    end)
  end


  def read(lines, default \\ 0) do
    vals = Enum.with_index(lines, fn line, y ->
      Enum.with_index(String.to_charlist(line), fn ch, x ->
        val = case ch do
          ?# -> 1
          ?. -> 0
          _ -> raise "Unexpected character"
        end
        {{y, x}, val}
      end)
    end)
    |> Enum.concat
    Image.new(Map.new(vals), default)
  end

  def print(img) do
    {miny, maxy, minx, maxx} = inclusive_extents(img)
    io_data = Enum.map(miny..maxy, fn y ->
      [Enum.map(minx..maxx, fn x ->
         case sample(img, {y, x}) do
           1 -> ?#
           0 -> ?.
         end
      end), "\n"]
    end)
    IO.puts(io_data)
  end

end


defmodule Day20 do

  defp read_data(fname) do
    {:ok, contents} = File.read(fname)

    lines = contents
    |> String.split("\n", trim: true)

    lut = Image.read(Enum.take(lines, 1))
    img = Image.read(Enum.drop(lines, 1))
    {img, lut}
  end

  defp to_index(lst) do
    lst
    |> Enum.map(&(&1 + ?0))
    |> List.to_integer(2)
  end

  defp filter(img, lut) do
    new_default = Image.read_lut(lut, img.default*511)
    {miny, maxy, minx, maxx} = Image.inclusive_extents(img)
    new_map = for y <- miny-1..maxy+1, x <- minx-1..maxx+1, into: %{}, do: {{y, x}, Image.read_lut(lut, to_index(Image.sample3x3(img, {y, x})))}
    Image.new(new_map, new_default)
  end

  defp count(img) do
    img.image
    |> Map.values
    |> Enum.sum
  end
  def run_a do
    {img, lut} = read_data("day20_input.txt")
    final_img = Enum.reduce(1..2, img, fn _, image -> filter(image, lut) end)
    IO.puts(count(final_img))
  end

  def run_b do
    {img, lut} = read_data("day20_input.txt")
    final_img = Enum.reduce(1..50, img, fn _, image -> filter(image, lut) end)
    IO.puts(count(final_img))
  end



end

Day20.run_a()
Day20.run_b()
