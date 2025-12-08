defmodule Main do
  @file_path "day04/input.txt"
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
    lines =
      @file_path
      |> File.read!()
      |> String.split(@separator, trim: true)

    rows = length(lines)
    cols = lines |> List.first() |> String.length()

    board = Enum.map(lines, &String.split(&1, "", trim: true))

    {rows, cols, board}
  end

  defp part1({rows, cols, board}) do
    for row <- 0..(rows - 1),
        col <- 0..(cols - 1) do
      item = board |> Enum.at(row) |> Enum.at(col)

      if item == "@" do
        can_pass?(board, row, col)
      end
    end
    |> Enum.filter(&Function.identity/1)
    |> Enum.count()
  end

  defp part2(input) do
    update_board(0, input)
  end

  defp update_board(removed_total, {rows, cols, board}) do
    {removed, new_board} =
      for row <- 0..(rows - 1),
          col <- 0..(cols - 1),
          reduce: {0, board} do
        {n, new_board} ->
          item = new_board |> Enum.at(row) |> Enum.at(col)

          {new_item, removed} =
            cond do
              item == "@" and can_pass?(new_board, row, col) ->
                {".", 1}

              true ->
                {item, 0}
            end

          {n + removed, put_in(new_board, [Access.at(row), Access.at(col)], new_item)}
      end

    if removed == 0 do
      removed_total
    else
      update_board(removed_total + removed, {rows, cols, new_board})
    end
  end

  defp can_pass?(board, row, col) do
    [
      {row - 1, col - 1},
      {row - 1, col},
      {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col - 1},
      {row + 1, col},
      {row + 1, col + 1}
    ]
    |> Enum.sum_by(fn
      {rown, coln} when rown < 0 or coln < 0 ->
        0

      {rown, coln} ->
        neighbor_row = Enum.at(board, rown)
        neighbor = Enum.at(neighbor_row || [], coln)

        if(neighbor == "@", do: 1, else: 0)
    end)
    |> Kernel.<(4)
  end
end

Main.call()
