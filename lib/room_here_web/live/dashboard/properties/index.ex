defmodule RoomHereWeb.Properties.Index do
  use RoomHereWeb, :live_component

  alias RoomHere.Listings

  def mount(socket) do
    {:ok, socket}
  end

  def preload([assigns]) do
    properties = Listings.list_properties_with_user(assigns.user)

    assigns = Map.put(assigns, :properties, properties)
    [assigns]
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
