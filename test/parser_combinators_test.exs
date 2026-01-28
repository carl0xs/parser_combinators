defmodule ParserCombinatorsTest do
  use ExUnit.Case
  doctest ParserCombinators

  alias ParserCombinators, as: P

  test "digit/1" do
    assert {:ok, 1, ""} = P.digit("1")
  end

  test "digit/1as2" do 
    assert {:ok, 1, "as2"} = P.digit("1as2")
  end

  test "digit/s234" do 
    assert %{error: "digit not found", input: "s234"} = P.digit("s234")
  end

  test "letter/a" do
    assert {:ok, "a", ""} = P.letter("a")
  end

  test "letter/as2" do 
    assert {:ok, "a", "s2"} = P.letter("as2")
  end

  test "letter/234" do 
    assert %{error: "letter not found", input: "234"} = P.letter("234")
  end
end
