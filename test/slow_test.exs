defmodule SlowTest do
  use ExUnit.Case
  doctest Slow

  test "greets the world" do
    assert Slow.hello() == :world
  end
end
