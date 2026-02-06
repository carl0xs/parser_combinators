defmodule ParserCombinatorsTest do
  use ExUnit.Case
  doctest ParserCombinators

  alias ParserCombinators, as: P

  test "satisfy digit/1" do
    assert {:ok, "1", ""} = P.digit().("1")
  end

  test "satisfy di[git/1as2" do 
    assert {:ok, "1",  "as2"} = P.digit().("1as2")
  end

  test "satisfy digit/s234" do 
    assert {:error, "didn't satisfy condition",  "s234"} = P.digit().("s234")
  end

  test "satisfy letter/a" do
    assert {:ok, "a",  ""} = P.letter().("a")
  end

  test "satisfy letter/as2" do 
    assert {:ok, "a",  "s2"} = P.letter().("as2")
  end

  test "satisfy letter/234" do 
    assert {:error, "didn't satisfy condition",  "234"} = P.letter().("234")
  end

  test "satisfy char/a" do
    assert {:ok, "a", "bc"} = P.char("a").("abc")

    assert {:error, "didn't satisfy condition", "abc"} = P.char("b").("abc")
  end

  test "many letter/abc123" do
    letters_as_string =
      P.many(P.letter)

    assert {:ok, ["a", "b", "c"], "123"} = letters_as_string.("abc123")

    assert {:ok, [], "123"} = letters_as_string.("123")
  end

  test "many with map/123 to integer" do
    to_int = P.map(P.many(P.digit), fn digits -> digits 
      |> Enum.join("") 
      |> String.to_integer() end)

    assert {:ok, 123, ""} = to_int.("123")
  end

  test "letter or digits" do
    letter_or_digit = 
      P._or(P.digit, P.letter)

    assert {:ok , "a", "bc"} = letter_or_digit.("abc")

    assert {:ok , "1", "23"} = letter_or_digit.("123")
  end

  test "any" do
    letter_or_digit = 
      P.any([P.digit, P.letter])

    assert {:ok , "a", "bc"} = letter_or_digit.("abc")

    assert {:ok , "1", "23"} = letter_or_digit.("123")
  end
  
  test "_and digit and letter/1a" do
    digit_and_letter =
      P._and(P.digit, P.letter)

    assert {:ok, ["1", "a"], ""} = digit_and_letter.("1a")
  end

  test "_and digit and letter/1a error" do
    digit_and_letter =
      P._and(P.digit, P.letter)

    assert {:error, "didn't satisfy condition", "a1"} = digit_and_letter.("a1")
  end

  test "preceeded" do
    assert {:ok, "1", ""} = P.preceeded(P.char("x"), P.digit).("x1")
  end

  test "terminated" do
    letters = P.map(P.many(P.letter), fn r -> r |> Enum.join("") end)
    assert {:ok, "lol", ""} = P.terminated(letters, P.char(":")).("lol:")
  end

  test "string single and double quoted" do
    letters = P.map(P.many(P.letter), fn r -> r |> Enum.join("") end)
    double = P.delimited(P.char(~s'"'), letters, P.char(~s'"'))
    single = P.delimited(P.char(~s"'"), letters, P.char(~s"'"))
    quoted = P._or(double, single)

    # double quoted
    assert {:ok, "abc", ""} = quoted.(~s'"abc"')

    # single quoted
    assert {:ok, ~s'abc', ""} = single.("'abc'")
  end

  test "sequence" do 
    letters = P.map(P.many(P.letter), fn r -> r |> Enum.join("") end)
    quoted = P.sequence(P.any([P.char("'"), P.char(~s'"'), P.char("`")]), fn 
      quote -> P.terminated(letters, P.satisfy(
        fn char -> 
          char != quote 
        end)) 
    end)

    assert {:ok, "abc", quoted.(~s'"abc"')}
    assert {:ok, "abc", quoted.("'abc'")}

    assert {:ok, "abc--s2_+2_+", quoted.("abc--s2_+2_+")}
  end
end
