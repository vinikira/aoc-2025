defmodule Main do
  @file_path "day05/input.txt"
  @ranges_separator "\n\n"
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
    [ranges_str, ids_str] =
      @file_path
      |> File.read!()
      |> String.split(@ranges_separator, trim: true)

    ranges =
      ranges_str
      |> String.split(@separator, trim: true)
      |> Enum.map(fn str ->
        [range_start, range_end] = String.split(str, "-")
        Range.new(String.to_integer(range_start), String.to_integer(range_end))
      end)

    ids =
      ids_str
      |> String.split(@separator, trim: true)
      |> Enum.map(fn str ->
        String.to_integer(str)
      end)

    {ranges, ids}
  end

  defp part1({ranges, ids}) do
    Enum.count(ids, fn id ->
      Enum.any?(ranges, fn range -> id in range end)
    end)
  end

  defp part2({ranges, _ids}) do
    ranges
    |> Enum.sort()
    |> combine_ranges()
    |> Enum.reduce(0, fn range, acc -> acc + Range.size(range) end)
  end

  defp combine_ranges([r]), do: [r]

  defp combine_ranges([r1, r2 | rest]) do
    if Range.disjoint?(r1, r2) do
      [r1 | combine_ranges([r2 | rest])]
    else
      new_range = min(r1.first, r2.first)..max(r1.last, r2.last)

      combine_ranges([new_range | rest])
    end
  end
end

Main.call()
