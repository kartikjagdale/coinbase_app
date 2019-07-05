defmodule CoinbaseAppTest do
  use ExUnit.Case
  doctest CoinbaseApp

  test "greets the world" do
    assert CoinbaseApp.hello() == :world
  end
end
