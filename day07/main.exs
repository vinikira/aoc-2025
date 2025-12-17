defmodule Main do
  @file_path "day07/input.txt"
  @separator_line "\n"

  def call do
    input = read_input()

    result = part1(input)

    IO.puts("""
    PART 1
    --------------------------------------------------
    sum: #{result}
    """)

    :ets.new(:cache_table, [:set, :protected, :named_table])

    result = part2(input)

    IO.puts("""
    PART 2
    --------------------------------------------------
    sum: #{result}
    """)
  end

  defp read_input do
    lines =
      @file_path
      |> File.read!()
      |> String.split(@separator_line, trim: true)

    rows = length(lines)
    cols = lines |> hd() |> String.length()

    board =
      lines
      |> Enum.with_index()
      |> Enum.flat_map(fn {item, row} ->
        item
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Enum.map(fn {item, col} -> {{row, col}, item} end)
      end)
      |> Map.new()

    {board, rows, cols}
  end

  def part1({board, rows, cols}) do
    {_board, total} =
      for row <- 0..(rows - 2), col <- 0..(cols - 1), reduce: {board, 0} do
        {acc, total} ->
          current_item = Map.fetch!(acc, {row, col})
          {new_acc, to_add} = process_item(current_item, acc, row, col)

          {new_acc, total + to_add}
      end

    total
  end

  defp process_item("S", board, row, col), do: {Map.put(board, {row + 1, col}, "|"), 0}

  defp process_item("|", board, row, col) do
    next = Map.fetch!(board, {row + 1, col})

    case next do
      "^" ->
        board
        |> Map.put({row + 1, col - 1}, "|")
        |> Map.put({row + 1, col + 1}, "|")
        |> then(&{&1, 1})

      "." ->
        process_item("S", board, row, col)

      _else ->
        process_item(".", board, row, col)
    end
  end

  defp process_item(_item, board, _row, _col), do: {board, 0}

  def part2(input, start_row \\ 0, start_col \\ 0)

  def part2({_board, rows, cols}, start_row, start_col)
      when start_row == rows - 1 and start_col == cols - 1, do: 0

  def part2({board, rows, cols}, start_row, start_col) do
    {_board, total} =
      for row <- start_row..(rows - 2), col <- start_col..(cols - 1), reduce: {board, 1} do
        {acc, total} ->
          current_item = Map.fetch!(acc, {row, col})

          {new_acc, to_add} = process_item_v2(current_item, {acc, rows, cols}, row, col)

          {new_acc, total + to_add}
      end

    total
  end

  defp process_item_v2("S", {board, _rows, _cols}, row, col),
    do: {Map.put(board, {row + 1, col}, "|"), 0}

  defp process_item_v2("|", {board, rows, cols}, row, col) do
    next = Map.fetch!(board, {row + 1, col})

    case next do
      "^" ->
        world1 = Map.put(board, {row + 1, col - 1}, "|")

        total =
          case :ets.lookup(:cache_table, {row, col}) do
            [] ->
              world2 = Map.put(board, {row + 1, col + 1}, "|")

              total = part2({world2, rows, cols}, row + 1, 0)

              :ets.insert(:cache_table, {{row, col}, total})

              total

            [{_key, total}] ->
              total
          end

        {world1, total}

      "." ->
        process_item_v2("S", {board, rows, cols}, row, col)

      _else ->
        process_item_v2(".", {board, rows, cols}, row, col)
    end
  end

  defp process_item_v2(_item, {board, _rows, _cols}, _row, _col), do: {board, 0}
end

Main.call()
