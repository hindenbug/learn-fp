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
    {game, tally(game)}
  end

  def make_move(game, guess) do
    game = accept_move(game, guess, MapSet.member?(game.used, guess))
    {game, tally(game)}
  end

  def accept_move(game, guess, _already_guessed = true) do
    Map.put(game, :game_state, :already_used)
  end

  def accept_move(game, guess, _already_guessed) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score(Enum.member?(game.letters, guess))
  end

  def score(game, _correct_guess = true) do
    new_state =
      MapSet.new(game.letters)
      |> MapSet.subset?(game.used)
      |> won?()

    Map.put(game, :game_state, new_state)
  end

  def score(game = %{turns_left: 1}, _incorrect_guess) do
    %{game | game_state: :lost, turns_left: 0}
  end

  def score(game = %{turns_left: turns_left}, _incorrect_guess) do
    %{game | game_state: :incorrect_guess, turns_left: turns_left - 1}
  end

  def won?(true), do: :won
  def won?(_), do: :correct_guess

  def tally(_game) do
    4 + 4
  end
end
