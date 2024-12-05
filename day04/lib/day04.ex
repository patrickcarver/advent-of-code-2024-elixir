defmodule Day04 do
  @directions [
    # north
    [{0, 0}, {0, -1}, {0, -2}, {0, -3}],
    # south
    [{0, 0}, {0, 1}, {0, 2}, {0, 3}],
    # west
    [{0, 0}, {-1, 0}, {-2, 0}, {-3, 0}],
    # east
    [{0, 0}, {1, 0}, {2, 0}, {3, 0}],
    # nw
    [{0, 0}, {-1, -1}, {-2, -2}, {-3, -3}],
    # ne
    [{0, 0}, {1, -1}, {2, -2}, {3, -3}],
    # sw
    [{0, 0}, {-1, 1}, {-2, 2}, {-3, 3}],
    # se
    [{0, 0}, {1, 1}, {2, 2}, {3, 3}]
  ]

  @xmas ~w[X M A S]

  def part1(file_name \\ "input.txt") do
    ("priv/" <> file_name)
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> build_grid()
    |> count_xmas()
  end

  defp count_xmas(grid) do
    coords = Map.keys(grid)

    Enum.reduce(coords, 0, fn {x, y} = coord, acc ->
      count =
        Enum.reduce(@directions, 0, fn direction, dir_acc ->
          candidate =
            Enum.map(direction, fn {dir_x, dir_y} -> Map.get(grid, {x + dir_x, y + dir_y}) end)

          if candidate == @xmas do
            dir_acc + 1
          else
            dir_acc
          end
        end)

      acc + count
    end)
  end

  defp build_grid(stream) do
    for {line, y} <- Enum.with_index(stream),
        {letter, x} <- Enum.with_index(String.graphemes(line)),
        do: {{x, y}, letter},
        into: Map.new()
  end
end
