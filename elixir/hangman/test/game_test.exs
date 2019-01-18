defmodule GameTest do
  use ExUnit.Case

  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    assert Enum.all?(game.letters, fn x -> x == String.downcase(x) end) == true
  end

  test "state doesn't change for :won game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)

      assert {^game, _} = Game.make_move(game, "x")
    end
  end

  test "first occurrence of letter is not already used" do
    game = Game.new_game()

    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurrence of letter is already used" do
    game = Game.new_game()

    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used

    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a correct guess" do
    game = Game.new_game("testword")

    {game, _} = Game.make_move(game, "t")
    assert game.game_state == :correct_guess
    assert game.turns_left == 7
  end

  test "a correct word wins the game" do
    moves = [
      {"t", :correct_guess, 7},
      {"e", :correct_guess, 7},
      {"x", :incorrect_guess, 6},
      {"s", :won, 6}
    ]

    game = Game.new_game("test")

    Enum.reduce(moves, game, fn {guess, state, turns_left}, game ->
      {game, _tally} = Game.make_move(game, guess)
      assert game.game_state == state
      assert game.turns_left == turns_left
      game
    end)
  end

  test "incorrect guesses looses the game" do
    moves = [
      {"x", :incorrect_guess, 6},
      {"r", :incorrect_guess, 5},
      {"6", :incorrect_guess, 4},
      {"h", :incorrect_guess, 3},
      {"i", :incorrect_guess, 2},
      {"j", :incorrect_guess, 1},
      {"k", :lost, 0}
    ]

    game = Game.new_game("test")

    Enum.reduce(moves, game, fn {guess, state, turns_left}, game ->
      {game, _tally} = Game.make_move(game, guess)
      assert game.game_state == state
      assert game.turns_left == turns_left
      game
    end)
  end
end
