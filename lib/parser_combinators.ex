defmodule ParserCombinators do
  @moduledoc false

  def digit(<<c, rest::binary>>) when c in ?0..?9 do
    {:ok, c - ?0, rest}
  end

  def digit(input), do: %{error: "digit not found", input: input}

  def letter(<<c, rest::binary>>) when c in ?a..?z or c in ?A..?Z do
    {:ok, <<c>>, rest}
  end

  def letter(input), do: %{error: "letter not found", input: input}
end
