defmodule RoomHere.Factory do
  use ExMachina.Ecto, repo: RoomHere.Repo
  use RoomHere.UserFactory
  use RoomHere.PropertyFactory
  use RoomHere.PropertyUserFactory
end
