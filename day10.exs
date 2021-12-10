#! /usr/bin/env elixir

defmodule Day10 do



  defp read_data(fname) do
    {:ok, contents} = File.read(fname)
    contents
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end


  defp score_a(token) do
    case token do
      ?) -> 3
      ?] -> 57
      ?} -> 1197
      ?> -> 25137
      _  -> 1
    end
  end

  defp parse_a([], _) do
    []
  end

  defp parse_a([token|rest_tokens], state) do
    case token do
      ?( -> parse_a(rest_tokens, [?) | state])
      ?[ -> parse_a(rest_tokens, [?] | state])
      ?{ -> parse_a(rest_tokens, [?} | state])
      ?< -> parse_a(rest_tokens, [?> | state])
      x -> if length(state) > 0 && hd(state) == x, do: parse_a(rest_tokens, tl(state)), else: [x]
    end
  end

  def run_a do
    lines = read_data("day10_input.txt")
    lines
    |> Enum.map(&(parse_a(&1, [])))
    |> Enum.concat
    |> Enum.map(&score_a/1)
    |> Enum.sum
    |> IO.puts
  end

  defp parse_b([], state) do
    state
  end

  defp parse_b([token|rest_tokens], state) do
    case token do
      ?( -> parse_b(rest_tokens, [?) | state])
      ?[ -> parse_b(rest_tokens, [?] | state])
      ?{ -> parse_b(rest_tokens, [?} | state])
      ?< -> parse_b(rest_tokens, [?> | state])
      x -> if length(state) > 0 && hd(state) == x, do: parse_b(rest_tokens, tl(state)), else: []
    end
  end

  defp score_b_token(token) do
    case token do
      ?) -> 1
      ?] -> 2
      ?} -> 3
      ?> -> 4
      _  -> 0
    end
  end
  defp score_b([], s) do
    s
  end

  defp score_b([token|rest_tokens], s) do
    score_b(rest_tokens, s*5 + score_b_token(token))
  end
  def run_b do
    lines = read_data("day10_input.txt")
    scores = lines
    |> Enum.map(&(parse_b(&1, [])))
    |> Enum.filter(&(length(&1) > 0))
    |> Enum.map(&(score_b(&1, 0)))
    |> Enum.sort

    IO.puts(Enum.at(scores, div(length(scores), 2)))
  end

end

Day10.run_a()
Day10.run_b()
