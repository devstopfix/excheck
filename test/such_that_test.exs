defmodule ExCheck.SuchThatTest do
  use ExUnit.Case
  use ExCheck

  # https://github.com/parroty/excheck/issues/14
  property :stj_such_that_constraints do
    for_all {s, t, j} in such_that({s_, t_, j_} in {int(), int(), int()} when s_ < j_ and j_ < t_) do
      assert j > s, inspect([s, j, t])
      assert j < t, inspect([s, j, t])
    end
  end

  defp gen_sjt,
    do:
      [int(), pos_integer(), pos_integer()]
      |> bind(fn [s, dj, dt] -> {s, s + dj, s + dj + dt} end)

  property :sjt_bind do
    for_all {s, j, t} in gen_sjt() do
      assert j > s, inspect([s, j, t])
      assert j < t, inspect([s, j, t])
    end
  end
end
