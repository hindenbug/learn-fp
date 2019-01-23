defmodule Hangman.Game do
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  def new_game(word) do
    %Hangman.Game{
      letters: word |> String.codepoints()
    }
  end

  def new_game() do
    new_game(Dictionary.random_word())
  end

  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    return_with_tally(game)
  end

  def make_move(game, guess) do
    accept_move(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally
  end

  def tally(game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters: game.letters |> reveal_guessed(game.used)
    }
  end

  defp accept_move(game, _guess, _already_guessed = true) do
    Map.put(game, :game_state, :already_used)
  end

  defp accept_move(game, guess, _already_guessed) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score(Enum.member?(game.letters, guess))
  end

  defp score(game, _correct_guess = true) do
    new_state =
      MapSet.new(game.letters)
      |> MapSet.subset?(game.used)
      |> won?()

    Map.put(game, :game_state, new_state)
  end

  defp score(game = %{turns_left: 1}, _incorrect_guess) do
    %{game | game_state: :lost, turns_left: 0}
  end

  defp score(game = %{turns_left: turns_left}, _incorrect_guess) do
    %{game | game_state: :incorrect_guess, turns_left: turns_left - 1}
  end

  defp won?(true), do: :won
  defp won?(_), do: :correct_guess

  defp reveal_guessed(letters, used) do
    letters
    |> Enum.map(fn letter ->
      reveal_letter(letter, MapSet.member?(used, letter))
    end)
  end

  defp reveal_letter(letter, _in_word = true), do: letter
  defp reveal_letter(_letter, _not_in_word), do: "_"

  defp return_with_tally(game), do: {game, tally(game)}
end
