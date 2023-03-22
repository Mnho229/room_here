defmodule RoomHere.Factory do
  use ExMachina.Ecto, repo: RoomHere.Repo
  use RoomHere.UserFactory
end
