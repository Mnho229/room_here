defmodule RoomHereWeb.Properties.Index do
  use RoomHereWeb, :live_component

  alias RoomHere.Listings
  alias RoomHere.Listings.Property

  alias RoomHereWeb.DashboardLive.DashboardComponents

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
    socket =
      socket
      |> assign(assigns)

    # |> show_modal_on_show(assigns.live_action_type)

    {:ok, socket}
  end

  # ------------------------------------------------

  # def show_modal_on_show(socket, :property_show) do
  #   assign(socket, :modal_open?, true)
  # end

  # def show_modal_on_show(socket, _live_action_type) do
  #   assign(socket, :modal_open?, false)
  # end

  # ------------------------------------------------

  def handle_event("close_modal", _, socket) do
    socket =
      socket
      |> assign(:modal_open?, false)
      |> push_patch(to: "/dashboard/properties")

    {:noreply, socket}
  end

  defp get_property(%{live_action_type: :property_new}), do: %Property{}
  defp get_property(%{live_action_type: _}), do: %Property{}
end
