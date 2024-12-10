defmodule Day07 do
  def part1(file_name \\ "input.txt") do
    ("priv/" <> file_name)
    |> parse()
    |> Enum.filter(fn {target, [start | rest]} ->
      is_possible(target, [start], rest)
    end)
    |> Enum.map(fn {target, _} -> target end)
    |> Enum.sum()
  end

  def part2(file_name \\ "input.txt") do
    ("priv/" <> file_name)
    |> parse()
    |> Enum.filter(fn {target, [start | rest]} ->
      is_possible2(target, [start], rest)
    end)
    |> Enum.map(fn {target, _} -> target end)
    |> Enum.sum()
  end

  def is_possible2(_target, [], _) do
    false
  end

  def is_possible2(_target, _, []) do
    false
  end

  # doesn't work on input.txt but works on test.txt
  def is_possible2(target, start, [next | rest]) do
    results =
      start
      |> Enum.flat_map(fn value -> [value + next, value * next, concat(value, next)] end)
      |> Enum.reject(fn value -> value > target end)

    if Enum.any?(results, fn value -> value == target end) do
      true
    else
      is_possible2(target, results, rest)
    end
  end

  def concat(value, next) do
    String.to_integer("#{value}#{next}")
  end

  defp is_possible(_target, [], _) do
    false
  end

  defp is_possible(_target, _, []) do
    false
  end

  defp is_possible(target, start, [next | rest]) do
    results =
      start
      |> Enum.flat_map(fn value -> [value + next, value * next] end)
      |> Enum.reject(fn value -> value > target end)

    if Enum.any?(results, fn value -> value == target end) do
      true
    else
      is_possible(target, results, rest)
    end
  end

  defp parse(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(fn line ->
      [target, raw_values] =
        line
        |> String.trim_trailing()
        |> String.split(": ")

      values = String.split(raw_values, " ") |> Enum.map(&String.to_integer/1)
      {String.to_integer(target), values}
    end)
  end
end
