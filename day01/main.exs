defmodule Main do
  @file_path "day01/input.txt"
  @separator "\n"
  @min 0
  @max 99
  @initial 50

  def call do
    input = read_input()

    {final_step, password} = Enum.reduce(input, {@initial, 0}, &rotate_part1/2)

    IO.puts("""
    PART 1
    --------------------------------------------------
    final step: #{final_step}
    password: #{password}
    """)

    {final_step, password} = Enum.reduce(input, {@initial, 0}, &rotate_part2/2)

    IO.puts("""
    PART 2
    --------------------------------------------------
    final step: #{final_step}
    password: #{password}
    """)
  end

  defp read_input do
    @file_path
    |> File.read!()
    |> String.trim()
    |> String.split(@separator)
  end

  defp rotate_part1(<<side::binary-size(1), times_str::binary>>, {current, password}) do
    times = String.to_integer(times_str)

    new_current =
      Enum.reduce(1..times, current, fn _i, new_current ->
        calculate(side, new_current)
      end)

    new_password =
      if new_current <= 0 do
        password + 1
      else
        password
      end

    {new_current, new_password}
  end

  defp rotate_part2(<<side::binary-size(1), times_str::binary>>, {current, password}) do
    times = String.to_integer(times_str)

    {new_current, zeroes} =
      Enum.reduce(1..times, {current, 0}, fn _i, {new_current, zeroes} ->
        result = calculate(side, new_current)

        new_zeroes = if result == 0, do: zeroes + 1, else: zeroes

        {result, new_zeroes}
      end)

    {new_current, password + zeroes}
  end

  defp calculate(?R, new_current) do
    result = new_current - 1
    if result < 0, do: @max, else: result
  end

  defp calculate(?L, new_current) do
    result = new_current + 1
    if result > @max, do: @min, else: result
  end
end

Main.call()
