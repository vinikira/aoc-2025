defmodule Main do
  @file_path "day02/input.txt"
  @separator ","
  @separator_range "-"

  def call do
    input = read_input()

    result = calculate_part1(input)

    IO.puts("""
    PART 1
    --------------------------------------------------
    sum: #{result}
    """)

    result = calculate_part2(input)

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
    |> Enum.flat_map(fn item ->
      [num1_str, num2_str] = String.split(item, @separator_range, trim: true)
      {num1, _rest} = Integer.parse(num1_str)
      {num2, _rest} = Integer.parse(num2_str)

      Enum.to_list(num1..num2)
    end)
  end

  defp calculate_part1(numbers_list) do
    numbers_list
    |> Enum.filter(&invalid_id?/1)
    |> Enum.sum()
  end

  defp invalid_id?(id) do
    digits = Integer.digits(id)
    id_digits_count = length(digits)

    if rem(id_digits_count, 2) != 0 do
      false
    else
      digits
      |> Enum.chunk_every(div(id_digits_count, 2))
      |> Enum.uniq()
      |> Enum.count()
      |> Kernel.==(1)
    end
  end

  defp calculate_part2(numbers_list) do
    numbers_list
    |> Enum.filter(&invalid_id2?/1)
    |> Enum.sum()
  end

  defp invalid_id2?(id) do
    digits = Integer.digits(id)
    id_digits_count = length(digits)

    Enum.any?(2..id_digits_count//1, fn num ->
      digits
      |> Enum.chunk_every(div(id_digits_count, num))
      |> Enum.uniq()
      |> Enum.count()
      |> Kernel.==(1)
    end)
  end
end

Main.call()
