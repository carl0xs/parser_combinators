defmodule ParserCombinators do
  @moduledoc false

  alias ParserCombinators, as: P

  def satisfy(predicate) when is_function(predicate, 1) do
    fn
      <<char::utf8, rest::binary>> ->
        if predicate.(<<char::utf8>>) do
          {:ok, result: <<char::utf8>>, rest: rest}
        else
          {:error, result: "didn't satisfy condition", rest: <<char::utf8, rest::binary>>}
        end

      input ->
        {:error, result: "empty input", rest: input}
    end
  end

  def digit do
    P.satisfy(fn <<c::utf8>> ->
      c in ?0..?9
    end)
  end

  def letter do
    P.satisfy(fn <<c::utf8>> ->
      c in ?a..?z or c in ?A..?Z
    end)
  end
end
