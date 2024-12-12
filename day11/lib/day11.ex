defmodule Day11 do
  def part1(file_name \\ "input.txt") do
    run(file_name, 25)
  end

  def part2(file_name \\ "input.txt") do
    run(file_name, 75)
  end

  def run(file_name \\ "test.txt", blinks \\ 6) do
    ("priv/" <> file_name)
    |> load_data()
    |> blink(blinks)
  end

  def blink(stone_freqs, 0) do
    Enum.reduce(stone_freqs, 0, fn {_key, value}, acc -> acc + value end)
  end

  def blink(stone_freqs, blink) do
    new_stone_freqs =
      Enum.reduce(stone_freqs, %{}, fn {key, value}, acc ->
        cond do
          key == 0 ->
            Map.update(acc, 1, value, &(&1 + value))

          has_even_num_of_digits(key) ->
            key
            |> split_digits()
            |> Enum.reduce(acc, fn new_key, current_acc ->
              Map.update(current_acc, new_key, value, &(&1 + value))
            end)

          true ->
            Map.update(acc, key * 2024, value, &(&1 + value))
        end
      end)

    blink(new_stone_freqs, blink - 1)
  end

  def has_even_num_of_digits(num) do
    count = num |> Integer.digits() |> length()
    rem(count, 2) == 0
  end

  # I knew there was a "mathy" way to split an integer in half that would be efficient,
  # but thanks to ChatGPT for providing an example.
  # Originally I was using Enum.split and Integer.undigit to make it happen.
  def split_digits(num) do
    half = num |> Integer.digits() |> length() |> div(2)

    divisor = 10 ** half

    first = div(num, divisor)
    last = rem(num, divisor)

    [first, last]
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
    |> Enum.frequencies()
  end
end
