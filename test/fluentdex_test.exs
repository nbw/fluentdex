defmodule FluentdexTest do
  use ExUnit.Case
  doctest Fluentdex

  test "greets the world" do
    assert Fluentdex.hello() == :world
  end
end
