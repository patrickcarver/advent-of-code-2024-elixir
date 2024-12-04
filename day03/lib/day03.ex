defmodule Day03 do
  @multiply_regex ~r/(?<=mul\()\d{1,3},\d{1,3}(?=\))/
  @do_regex ~r/(?<=do\(\))(.+?)(?=don\'t\(\))/

  def part1(file_name \\ "input.txt") do
    ("priv/" <> file_name)
    |> File.stream!()
    |> Stream.map(fn line ->
      line
      |> String.trim_trailing()
      |> parse_multiply()
    end)
    |> Enum.sum()
  end

  def part2(file_name \\ "input.txt") do
    text =
      ("priv/" <> file_name)
      |> File.read!()
      |> String.replace("\n", "")
      |> then(fn input ->
        if String.starts_with?(input, "do()") do
          input
        else
          "do()" <> input
        end
      end)

    Regex.scan(@do_regex, text, capture: :first)
    |> List.flatten()
    |> Enum.map(&parse_multiply/1)
    |> Enum.sum()
  end

  defp parse_multiply(line) do
    Regex.scan(@multiply_regex, line)
    |> List.flatten()
    |> Enum.map(fn text ->
      text
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.product()
    end)
    |> Enum.sum()
  end
end
