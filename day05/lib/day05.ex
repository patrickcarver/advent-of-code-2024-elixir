defmodule Day05 do
  # Hat tip to: https://github.com/frerich/aoc2024/blob/main/elixir/day05/day05.exs
  # I had struggled using maps to store and process the rules, but I came across this
  # very elegant use of sorting the updates

  def part1(file_name \\ "input.txt") do
    {rules, updates} = parse("priv/" <> file_name)

    updates
    |> Enum.filter(&(&1 == sort(&1, rules)))
    |> Enum.map(&middle/1)
    |> Enum.sum()
  end

  def part2(file_name \\ "input.txt") do
    {rules, updates} = parse("priv/" <> file_name)

    updates
    |> Enum.reject(&(&1 == sort(&1, rules)))
    |> Enum.map(&(&1 |> sort(rules) |> middle()))
    |> Enum.sum()
  end

  defp middle(update) do
    Enum.at(update, div(length(update), 2))
  end

  defp sort(update, rules) do
    Enum.sort(update, fn a, b -> [a, b] in rules end)
  end

  defp parse(file_name) do
    [raw_rules, raw_updates] =
      file_name
      |> File.read!()
      |> String.split("\n\n")
      |> Enum.map(&String.split(&1, "\n"))

    rules =
      raw_rules
      |> Enum.map(fn value ->
        value
        |> String.split("|")
        |> Enum.map(&String.to_integer/1)
      end)

    updates =
      raw_updates
      |> Enum.map(fn value ->
        value
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
      end)

    {rules, updates}
  end
end
