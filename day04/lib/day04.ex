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

  @xmas [{-1, -1}, {1, 1}, {-1, 1}, {1, -1}]

  def part1(file_name \\ "input.txt") do
    ("priv/" <> file_name)
    |> load_grid()
    |> count_xmas()
  end

  def part2(file_name \\ "input.txt") do
    ("priv/" <> file_name)
    |> load_grid()
    |> count_x_mas()
  end

  defp load_grid(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
    |> build_grid()
  end

  defp count_xmas(grid) do
    coords = Map.keys(grid)

    Enum.reduce(coords, 0, fn {x, y}, acc ->
      count =
        Enum.reduce(@directions, 0, fn direction, dir_acc ->
          candidate =
            Enum.map(direction, fn {dir_x, dir_y} -> Map.get(grid, {x + dir_x, y + dir_y}) end)

          if candidate == ~w[X M A S] do
            dir_acc + 1
          else
            dir_acc
          end
        end)

      acc + count
    end)
  end

  defp count_x_mas(grid) do
    letter_as = grid |> Map.filter(fn {_, letter} -> letter == "A" end) |> Map.keys()

    Enum.reduce(letter_as, 0, fn {x, y}, acc ->
      candidate =
        Enum.map(@xmas, fn {dir_x, dir_y} -> Map.get(grid, {x + dir_x, y + dir_y}) end)

      if candidate in [~w[M S M S], ~w[M S S M], ~w[S M S M], ~w[S M M S]] do
        acc + 1
      else
        acc
      end
    end)
  end

  defp build_grid(stream) do
    for {line, y} <- Enum.with_index(stream),
        {letter, x} <- Enum.with_index(String.graphemes(line)),
        do: {{x, y}, letter},
        into: Map.new()
  end
end
