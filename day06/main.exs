defmodule Main do
  @file_path "day06/input.txt"
  @separator_line "\n"
  @separator ~r"\s+"

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
    |> String.split(@separator_line, trim: true)
  end

  defp part1(input) do
    input
    |> Enum.map(&String.split(&1, @separator, trim: true))
    |> Enum.zip_with(&Function.identity/1)
    |> Enum.map(fn list_ops ->
      Enum.reduce(list_ops, [], fn
        "*", acc -> Enum.product(acc)
        "+", acc -> Enum.sum(acc)
        num, acc -> [String.to_integer(num) | acc]
      end)
    end)
    |> Enum.sum()
  end

  defp part2(input) do
    input
    |> Enum.map(&String.split(&1, ""))
    |> Enum.zip_with(&Function.identity/1)
    |> Enum.reverse()
    |> Enum.reduce({[], 0}, fn i, {acc, total} ->
      result = i |> Enum.join() |> String.trim() |> Integer.parse()

      case result do
        :error ->
          {acc, total}

        {num, op} ->
          op = String.trim(op)

          cond do
            op == "+" ->
              {[], Enum.sum([num | acc]) + total}

            op == "*" ->
              {[], Enum.product([num | acc]) + total}

            true ->
              {[num | acc], total}
          end
      end
    end)
    |> elem(1)
  end
end

Main.call()
