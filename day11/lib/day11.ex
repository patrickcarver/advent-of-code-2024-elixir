defmodule Day11 do
  def part1(file_name \\ "test.txt", blinks \\ 6) do
    ("priv/" <> file_name)
    |> load_data()
    |> apply_rules(blinks)
  end

  def has_even_num_of_digits(num) do
    count = num |> Integer.digits() |> length()
    rem(count, 2) == 0
  end

  def split_digits(num) do
    digits = Integer.digits(num)
    split = round(length(digits) / 2)

    digits |> Enum.split(split) |> Tuple.to_list() |> Enum.map(&Integer.undigits/1)
  end

  def apply_rules(stones, 0) do
    length(stones)
  end

  def apply_rules(stones, blink) do
    new_stones =
      Enum.flat_map(stones, fn stone ->
        cond do
          stone == 0 ->
            [1]

          has_even_num_of_digits(stone) ->
            split_digits(stone)

          true ->
            [stone * 2024]
        end
      end)

    apply_rules(new_stones, blink - 1)
  end

  def load_data(file_name) do
    file_name
    |> File.stream!()
    |> Enum.map(fn line ->
      line
      |> String.trim_trailing()
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
    end)
    |> hd()
  end
end
