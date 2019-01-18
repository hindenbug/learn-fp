defmodule TextClient.State do
  defstruct(
    game_service: nil,
    tally: nil,
    last_letter: ""
  )
end
