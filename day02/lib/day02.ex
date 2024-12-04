defmodule Day02 do
  def part1(file_name \\ "input.txt") do
    ("priv/" <> file_name)
    |> parse_reports()
    |> determine_safety()
    |> Enum.count(&(&1 == :safe))
  end

  def part2(file_name \\ "input.txt") do
    ("priv/" <> file_name)
    |> parse_reports()
    |> then(fn reports ->
      Enum.map(reports, fn report ->
        statuses =
          for i <- 0..(length(report) - 1) do
            List.delete_at(report, i)
          end
          |> determine_safety()

        if Enum.any?(statuses, &(&1 == :safe)) do
          :safe
        else
          :unsafe
        end
      end)
    end)
    |> Enum.count(&(&1 == :safe))
  end

  defp determine_safety(reports) do
    Stream.map(reports, fn report ->
      diffs = diffs(report)

      with true <- Enum.all?(diffs, &(&1 != 0)),
           true <- Enum.all?(diffs, &(&1 in 1..3)),
           true <- report == Enum.sort(report, :asc) || report == Enum.sort(report, :desc) do
        :safe
      else
        false ->
          :unsafe
      end
    end)
  end

  defp diffs(report) do
    report
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [f, s] -> abs(f - s) end)
  end

  defp parse_reports(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(fn line ->
      line
      |> String.trim_trailing()
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
