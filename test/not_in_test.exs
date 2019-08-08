defmodule NotInTest do
  use ExUnit.Case
  use ExCheck

  # https://github.com/parroty/excheck/issues/39
  property :not_in_suchthat do
    for_all {x, ys} in such_that({x_, ys_} in {int(), list(int())} when !Enum.member?(ys_, x_)) do
      assert Enum.member?(ys, x) == false
    end
  end

  def gen_x_yys_filter do
    [:triq_dom.int(), list(:triq_dom.int())]
    |> bind(fn [x, ys] ->
      {x, Enum.filter(ys, fn y -> x != y end)}
    end)
  end

  property :not_in_filter do
    for_all {x, ys} in gen_x_yys_filter() do
      assert Enum.member?(ys, x) == false
    end
  end
end
