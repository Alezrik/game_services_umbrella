defmodule ClusterManagerTest do
  use ExUnit.Case
  doctest ClusterManager

  test "greets the world" do
    assert ClusterManager.hello() == :world
  end
end
