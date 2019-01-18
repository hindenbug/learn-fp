defmodule TextClient.Player do
  alias TextClient.{Mover, Prompter, State, Summary}

  def play(game = %State{tally: %{game_state: :won}}) do
    exit_with_message("You WON!!!")
  end

  def play(game = %State{tally: %{game_state: :lost}}) do
    exit_with_message("Sorry you LOST!!!")
  end

  def play(game = %State{tally: %{game_state: :correct_guess}}) do
    continue_with_message(game, "Good guess!!")
  end

  def play(game = %State{tally: %{game_state: :incorrect_guess}}) do
    continue_with_message(game, "Wrong guess!!")
  end

  def play(game = %State{tally: %{game_state: :already_used}}) do
    continue_with_message(game, "Already used!")
  end

  def play(game) do
    continue(game)
  end

  defp continue_with_message(game, message) do
    IO.puts(message)
    continue(game)
  end

  defp continue(game) do
    game
    |> Summary.display()
    |> Prompter.prompt()
    |> Mover.make_move()
    |> play()
  end

  defp exit_with_message(msg) do
    IO.puts(msg)
    exit(:normal)
  end
end
