defmodule LoggerBackendTest do
  use ExUnit.Case
  doctest LoggerBackend

  test "greets the world" do
    assert LoggerBackend.hello() == :world
  end
end
