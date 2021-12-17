#! /usr/bin/env elixir
defmodule Day16 do

  def fire_step(px, py, vx, vy, v0, target) do
    {txmin, txmax, tymin, tymax} = target
    if px >= txmin && px <= txmax && py >= tymin && py <= tymax do
      {:hit, v0}
    else
      if (vy < 0 && py < tymin) || px > txmax || (vx <= 0 && px < txmin) do
        {:miss, v0}
      else
        px = px + vx
        py = py + vy
        vx = max(vx - 1, 0)
        vy = vy - 1
        fire_step(px, py, vx, vy, v0, target)
      end
    end
  end

  def fire(vx0, vy0, target) do
    fire_step(0, 0, vx0, vy0, {vx0, vy0}, target)
  end

  def find_all(target) do
    trials = for vx0 <- 0..400, vy0 <- -100..100, do: fire(vx0, vy0, target)

    trials
    |> Enum.filter(fn {code, _} -> code == :hit end)
  end

  def find_highest(target) do
    find_all(target)
    |> Enum.map(fn {:hit, {_, vy0}} -> div(vy0*(vy0+1), 2) end)
    |> Enum.max
  end

  def find_distinct(target) do
    find_all(target)
    |> length()
  end

  def run_a do
    result = find_highest({240, 292, -90, -57})
    IO.inspect(result)
  end




  def run_b do
    result = find_distinct({240, 292, -90, -57})
    IO.inspect(result)

  end

end

Day16.run_a()
Day16.run_b()
