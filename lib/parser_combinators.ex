defmodule ParserCombinators do
  @moduledoc false

  alias ParserCombinators, as: P

  def satisfy(predicate) when is_function(predicate, 1) do
    fn
      <<char::utf8, rest::binary>> ->
        token = <<char::utf8>>

        if predicate.(token) do
          {:ok, token, rest}
        else
          {:error, "didn't satisfy condition", <<char::utf8, rest::binary>>}
        end

      input ->
        {:error, "empty input", input}
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

  def many(parser) do
    fn input ->
      do_many(parser, input, [])
    end
  end

  defp do_many(parser, input, acc) do
    case parser.(input) do
      {:ok, result, rest} ->
        if rest == input do
          {:ok, Enum.reverse(acc), input}
        else
          do_many(parser, rest, [result | acc])
        end

      {:error, _reason, _rest} ->
        {:ok, Enum.reverse(acc), input}
    end
  end

  def map(parser, transform) do
    fn input ->
      case parser.(input) do
        {:ok, parsed, rest} ->
          {:ok, transform.(parsed), rest}

        :error ->
          {:error, [], input}
      end
    end
  end

  def _or(parser1, parser2) do
    fn input ->
      case parser1.(input) do
        {:ok, parsed, rest} ->
          {:ok, parsed, rest}

        {:error, _, _} ->
          parser2.(input)
      end
    end
  end
end
