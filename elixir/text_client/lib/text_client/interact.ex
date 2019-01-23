defmodule TextClient.Interact do
  @hangman_server :hangman@blackout

  alias TextClient.{Player, State}

  def start do
    new_game()
    |> setup_state()
    |> Player.play()
  end

  defp setup_state(game) do
    %TextClient.State{
      game_service: game,
      tally: Hangman.tally(game)
    }
  end

  def play(state) do
    play(state)
  end

  defp new_game() do
    Node.connect(@hangman_server)
    :rpc.call(@hangman_server, Hangman, :new_game, [])
  end
end
