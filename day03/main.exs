defmodule Main do
  @file_path "day03/input.txt"
  @separator "\n"

  def call do
    input = read_input()

    result = part1(input)

    IO.puts("""
    PART 1
    --------------------------------------------------
    sum: #{result}
    """)

    result = part2(input)

    IO.puts("""
    PART 2
    --------------------------------------------------
    sum: #{result}
    """)
  end

  defp read_input do
    @file_path
    |> File.read!()
    |> String.split(@separator, trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp part1(bank_list) do
    calculate(bank_list, 2)
  end

  defp part2(bank_list) do
    calculate(bank_list, 12)
  end

  defp calculate(bank_list, n) do
    bank_list
    |> Enum.map(fn bank ->
      digits = Integer.digits(bank)
      digits_len = length(digits)

      1..n
      |> Enum.reduce({[], 0}, fn pos, {numbers, digits_cursor} ->
        slice_n = digits_len - digits_cursor - (n - pos)

        {max, index} =
          digits
          |> Enum.slice(digits_cursor, slice_n)
          |> Enum.with_index()
          |> Enum.max_by(fn {n, _index} -> n end)

        {[max | numbers], digits_cursor + index + 1}
      end)
      |> elem(0)
      |> Enum.reverse()
      |> Integer.undigits()
    end)
    |> Enum.sum()
  end
end

Main.call()
