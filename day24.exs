#! /usr/bin/env elixir


defmodule Day24 do


  defmacro inp(term1) do
    quote do
      var!(unquote(term1)) = hd(var!(inputs))
      var!(inputs) = tl(var!(inputs))
    end
  end
  defmacro inp_last(term1) do
    quote do
      var!(unquote(term1)) = hd(var!(inputs))
    end
  end
  defmacro add(term1, term2) do
    quote do: var!(unquote(term1)) = unquote(term1) + unquote(term2)
  end
  defmacro mul(term1, term2) do
    quote do: var!(unquote(term1)) = unquote(term1) * unquote(term2)
  end
  defmacro diw(term1, term2) do
    quote do: var!(unquote(term1)) = div(unquote(term1), unquote(term2))
  end
  defmacro mod(term1, term2) do
    quote do: var!(unquote(term1)) = rem(unquote(term1), unquote(term2))
  end
  defmacro eql(term1, term2) do
    quote do: var!(unquote(term1)) = if unquote(term1) == unquote(term2), do: 1, else: 0
  end

  defp exec_program(inputs) do
    x = 0
    y = 0
    z = 0

    inp w
    mul x, 0
    add x, z
    mod x, 26
    diw z, 1
    add x, 11
    eql x, w
    eql x, 0
    mul y, 0
    add y, 25
    mul y, x
    add y, 1
    mul z, y
    mul y, 0
    add y, w
    add y, 6
    mul y, x
    add z, y

    inp w
    mul x, 0
    add x, z
    mod x, 26
    diw z, 1
    add x, 11
    eql x, w
    eql x, 0
    mul y, 0
    add y, 25
    mul y, x
    add y, 1
    mul z, y
    mul y, 0
    add y, w
    add y, 12
    mul y, x
    add z, y

    inp w
    mul x, 0
    add x, z
    mod x, 26
    diw z, 1
    add x, 15
    eql x, w
    eql x, 0
    mul y, 0
    add y, 25
    mul y, x
    add y, 1
    mul z, y
    mul y, 0
    add y, w
    add y, 8
    mul y, x
    add z, y

    inp w
    mul x, 0
    add x, z
    mod x, 26
    diw z, 26
    add x, -11
    eql x, w
    eql x, 0
    mul y, 0
    add y, 25
    mul y, x
    add y, 1
    mul z, y
    mul y, 0
    add y, w
    add y, 7
    mul y, x
    add z, y

    inp w
    mul x, 0
    add x, z
    mod x, 26
    diw z, 1
    add x, 15
    eql x, w
    eql x, 0
    mul y, 0
    add y, 25
    mul y, x
    add y, 1
    mul z, y
    mul y, 0
    add y, w
    add y, 7
    mul y, x
    add z, y

    inp w
    mul x, 0
    add x, z
    mod x, 26
    diw z, 1
    add x, 15
    eql x, w
    eql x, 0
    mul y, 0
    add y, 25
    mul y, x
    add y, 1
    mul z, y
    mul y, 0
    add y, w
    add y, 12
    mul y, x
    add z, y

    inp w
    mul x, 0
    add x, z
    mod x, 26
    diw z, 1
    add x, 14
    eql x, w
    eql x, 0
    mul y, 0
    add y, 25
    mul y, x
    add y, 1
    mul z, y
    mul y, 0
    add y, w
    add y, 2
    mul y, x
    add z, y

    inp w
    mul x, 0
    add x, z
    mod x, 26
    diw z, 26
    add x, -7
    eql x, w
    eql x, 0
    mul y, 0
    add y, 25
    mul y, x
    add y, 1
    mul z, y
    mul y, 0
    add y, w
    add y, 15
    mul y, x
    add z, y

    inp w
    mul x, 0
    add x, z
    mod x, 26
    diw z, 1
    add x, 12
    eql x, w
    eql x, 0
    mul y, 0
    add y, 25
    mul y, x
    add y, 1
    mul z, y
    mul y, 0
    add y, w
    add y, 4
    mul y, x
    add z, y

    inp w
    mul x, 0
    add x, z
    mod x, 26
    diw z, 26
    add x, -6
    eql x, w
    eql x, 0
    mul y, 0
    add y, 25
    mul y, x
    add y, 1
    mul z, y
    mul y, 0
    add y, w
    add y, 5
    mul y, x
    add z, y

    inp w
    mul x, 0
    add x, z
    mod x, 26
    diw z, 26
    add x, -10
    eql x, w
    eql x, 0
    mul y, 0
    add y, 25
    mul y, x
    add y, 1
    mul z, y
    mul y, 0
    add y, w
    add y, 12
    mul y, x
    add z, y

    inp w
    mul x, 0
    add x, z
    mod x, 26
    diw z, 26
    add x, -15
    eql x, w
    eql x, 0
    mul y, 0
    add y, 25
    mul y, x
    add y, 1
    mul z, y
    mul y, 0
    add y, w
    add y, 11
    mul y, x
    add z, y

    inp w
    mul x, 0
    add x, z
    mod x, 26
    diw z, 26
    add x, -9
    eql x, w
    eql x, 0
    mul y, 0
    add y, 25
    mul y, x
    add y, 1
    mul z, y
    mul y, 0
    add y, w
    add y, 13
    mul y, x
    add z, y

    inp_last w
    mul x, 0
    add x, z
    mod x, 26
    diw z, 26
    add x, 0
    eql x, w
    eql x, 0
    mul y, 0
    add y, 25
    mul y, x
    add y, 1
    mul z, y
    mul y, 0
    add y, w
    add y, 7
    mul y, x
    add z, y

    z
  end

  defp digit(dig, z, div1, add1, add2) do
    x = rem(z, 26) + add1
    z = div(z, div1)
    if x != dig do
      26 * z + (dig + add2)
    else
      z
    end
  end

  #given add1, try to find a digit that will make x == dig so that z does not increase. return 0 if this isn't possible
  def solve_digit_given_z(z, add1) do
    z = rem(z, 26)
    digit = z + add1
    if digit < 1 || digit > 9
    do
      0
    else
      digit
    end
  end




  defp solve_dependent_digits([d0, d1, d2, d4, d5, d6, d8]) do
    z = digit(d0,  0,  1, 11,  6)
    z = digit(d1,  z,  1, 11, 12)
    z = digit(d2,  z,  1, 15,  8)
    d3 = solve_digit_given_z(z, -11)
    z = digit(d3,  z, 26,-11,  7)
    z = digit(d4,  z,  1, 15,  7)
    z = digit(d5,  z,  1, 15, 12)
    z = digit(d6,  z,  1, 14,  2)
    d7 = solve_digit_given_z(z, -7)
    z = digit(d7,  z, 26, -7, 15)
    z = digit(d8,  z,  1, 12,  4)
    d9 = solve_digit_given_z(z, -6)
    z = digit(d9,  z, 26, -6,  5)
    d10 = solve_digit_given_z(z, -10)
    z = digit(d10, z, 26,-10, 12)
    d11 = solve_digit_given_z(z, -15)
    z = digit(d11, z, 26,-15, 11)
    d12 = solve_digit_given_z(z, -9)
    z = digit(d12, z, 26, -9, 13)
    d13 = solve_digit_given_z(z, 0)
    z = digit(d13, z, 26,  0,  7)
    if d3 == 0 || d7 == 0 || d9 == 0 || d10 == 0 || d11 == 0 || d12 == 0 || d13 == 0 do
      {1, []}
    else
      {z, [d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13]}
    end
  end




  defp num_to_digit_list(num) do
    Integer.to_string(num)
    |> String.to_charlist
    |> Enum.map(&(&1-?0))
  end
  defp digit_list_to_num(lst) do
    Enum.map(lst, &(&1+?0)) |> List.to_integer(10)
  end

  def sweep(val, incr) do
    lst = num_to_digit_list(val)
    [d0, d1, d2, d3, d4, d5, d6] = lst

    if d0 == 0 || d1 == 0 || d2 == 0 || d3 == 0 || d4 == 0 || d5 == 0 || d6 == 0  do
      sweep(val+incr, incr)
    else

      {res, digits} = solve_dependent_digits(lst)
      if res == 0 do
        digits
      else
        sweep(val+incr, incr)
      end
    end
  end

  def run_a do
    sol = sweep(9999999, -1)
    if exec_program(sol) != 0, do: "Solution is incorrect"
    IO.puts("Found highest serial number: #{digit_list_to_num(sol)}")
  end

  def run_b do
    sol = sweep(1111111, +1)
    if exec_program(sol) != 0, do: "Solution is incorrect"
    IO.puts("Found lowest serial number:  #{digit_list_to_num(sol)}")
  end



end

Day24.run_a()
Day24.run_b()
