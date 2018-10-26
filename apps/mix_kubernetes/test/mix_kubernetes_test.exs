defmodule MixKubernetesTest do
  use ExUnit.Case
  doctest MixKubernetes

  test "greets the world" do
    assert MixKubernetes.hello() == :world
  end
end
