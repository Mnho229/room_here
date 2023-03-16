defmodule RoomHereWeb.Properties.Index do
  use RoomHereWeb, :live_component

  alias RoomHere.Listings
  alias RoomHere.Listings.Property

  @property_tabs [
    {:property_index, "Index"},
    {:property_new, "New Property"}
  ]

  def mount(socket) do
    {:ok, socket}
  end

  def preload([assigns]) do
    properties = Listings.list_properties_with_user(assigns.user)

    assigns =
      assigns
      |> Map.put(:properties, properties)
      |> Map.put(:property, get_property(assigns))
      |> Map.put(:nav_list, @property_tabs)

    [assigns]
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end

  defp get_property(%{live_action_type: :property_new}), do: %Property{}
  defp get_property(%{live_action_type: _}), do: %Property{}
end
