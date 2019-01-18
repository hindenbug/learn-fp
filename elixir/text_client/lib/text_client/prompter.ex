defmodule TextClient.Prompter do
  alias TextClient.State

  def prompt(game = %{tally: tally}) do
    IO.gets("Your guess: ")
    |> check_input(game)
  end

  defp check_input({:error, reason}, _) do
    IO.puts("Game ended: #{reason}")
    exit(:normal)
  end

  defp check_input(:eof, _) do
    IO.puts("Give up.")
    exit(:normal)
  end

  defp check_input(input, game) do
    input = String.trim(input)

    cond do
      input =~ ~r/\A[a-z]\z/ ->
        Map.put(game, :guess, input)

      true ->
        IO.puts("Enter lowercase letter")
        prompt(game)
    end
  end
end
