defmodule Day06 do
  def part1(file_name \\ "input.txt") do
    grid = load_grid("priv/" <> file_name)
    guard_coords = guard_coords(grid, "^")
    visited = MapSet.new([guard_coords])
    direction = "^"
    grid = Map.put(grid, guard_coords, ".")

    travel(guard_coords, direction, visited, grid)
  end

  def part2(file_name \\ "input.txt") do
    "priv/" <> file_name
  end

  defp travel(guard_coords, direction, visited, grid) do
    next_position = next_position(guard_coords, direction)
    next_space = Map.get(grid, next_position)

    case next_space do
      "#" ->
        travel(guard_coords, rotate(direction), visited, grid)

      "." ->
        travel(next_position, direction, MapSet.put(visited, next_position), grid)

      nil ->
        MapSet.size(visited)

      value ->
        raise "The space at #{next_position} has an invalid value of #{value}"
    end
  end

  defp next_position({x, y}, direction) do
    case direction do
      "^" -> {x, y - 1}
      "v" -> {x, y + 1}
      "<" -> {x - 1, y}
      ">" -> {x + 1, y}
      value -> raise "The direction '#{value}' is not valid."
    end
  end

  defp rotate(direction) do
    case direction do
      "^" -> ">"
      "v" -> "<"
      ">" -> "v"
      "<" -> "^"
      value -> raise "The direction '#{value}' is not valid."
    end
  end

  defp guard_coords(grid, guard) do
    grid
    |> Map.filter(fn {_key, value} -> value == guard end)
    |> Map.keys()
    |> hd()
  end

  defp load_grid(file_name) do
    lines =
      file_name
      |> File.stream!()
      |> Stream.map(fn line -> line |> String.trim_trailing() |> String.graphemes() end)
      |> Enum.to_list()

    for {line, y} <- Enum.with_index(lines),
        {space, x} <- Enum.with_index(line),
        into: Map.new() do
      {{x, y}, space}
    end
  end
end
