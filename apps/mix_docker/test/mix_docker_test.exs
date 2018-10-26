defmodule MixDockerTest do
  use ExUnit.Case
  doctest MixDocker

  test "greets the world" do
    assert MixDocker.hello() == :world
  end
end
