defmodule ParserCombinatorsTest do
  use ExUnit.Case
  doctest ParserCombinators

  alias ParserCombinators, as: P

  test "satisfy digit/1" do
    assert {:ok, [result: "1", rest: ""]} = P.digit().("1")
  end

  test "satisfy di[git/1as2" do 
    assert {:ok, [result: "1", rest: "as2"]} = P.digit().("1as2")
  end

  test "satisfy digit/s234" do 
    assert {:error, [result: "didn't satisfy condition", rest: "s234"]} = P.digit().("s234")
  end

  test "satisfy letter/a" do
    assert {:ok, [result: "a", rest: ""]} = P.letter().("a")
  end

  test "satisfy letter/as2" do 
    assert {:ok, [result: "a", rest: "s2"]} = P.letter().("as2")
  end

  test "satisfy letter/234" do 
    assert {:error, [result: "didn't satisfy condition", rest: "234"]} = P.letter().("234")
  end
end
