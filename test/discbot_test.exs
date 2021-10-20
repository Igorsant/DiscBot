defmodule DiscbotTest do
  use ExUnit.Case
  doctest Discbot

  test "greets the world" do
    assert Discbot.hello() == :world
  end
end
