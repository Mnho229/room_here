defmodule RoomHere.Repo do
  use Ecto.Repo,
    otp_app: :room_here,
    adapter: Ecto.Adapters.Postgres
end
