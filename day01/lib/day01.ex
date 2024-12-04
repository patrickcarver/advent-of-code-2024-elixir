defmodule Day01 do
  def part1(file_name \\ "input.txt") do
    {first, second} = parse_lines_from_file("priv/" <> file_name)

    sorted_first = Enum.sort(first)
    sorted_second = Enum.sort(second)

    Stream.zip(sorted_first, sorted_second)
    |> Stream.map(fn {f, s} -> abs(f - s) end)
    |> Enum.sum()
  end

  def part2(file_name \\ "input.txt") do
    {first, second} = parse_lines_from_file("priv/" <> file_name)

    frequencies = Enum.frequencies(second)

    Stream.map(first, fn num ->
      num * Map.get(frequencies, num, 0)
    end)
    |> Enum.sum()
  end

  defp parse_lines_from_file(file_name) do
    file_name
    |> File.stream!()
    |> Enum.reduce({[], []}, fn line, {first_list, second_list} ->
      [first_num, second_num] = parse_line(line)
      {[first_num | first_list], [second_num | second_list]}
    end)
  end

  defp parse_line(line) do
    line
    |> String.trim_trailing()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end
