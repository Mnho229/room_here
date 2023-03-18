defmodule RoomHere.Listings.Property.Query do
  import Ecto.Query

  alias RoomHere.Listings.Property
  alias RoomHere.PropertyUser

  def base, do: from(p in Property, as: :property)

  def for_user(query \\ base(), user) do
    query
    |> join_property_user()
    |> filter_by_user(user)
    |> preload([property: p], :property_users)
  end

  # ---------------------------------------

  defp filter_by_user(query, user) do
    where(query, [property: p, property_user: pu], pu.user_id == ^user.id)
  end

  defp join_property_user(query) do
    join(query, :left, [p], pu in PropertyUser, on: p.id == pu.property_id, as: :property_user)
  end
end
