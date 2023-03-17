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

    # Revisit to make cleaner
    assigns = Map.put(assigns, :properties, properties)

    assigns =
      assigns
      |> Map.put(:property, get_property(assigns))
      |> Map.put(:nav_list, @property_tabs)

    [assigns]
  end

  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)
      |> assign(:view_tab, view_tab(assigns))

    {:ok, socket}
  end

  # ------------------------------------------------

  def handle_event("close_modal", _, socket) do
    socket =
      socket
      |> assign(:modal_open?, false)
      |> push_patch(to: "/dashboard/properties")

    {:noreply, socket}
  end

  defp view_tab(%{live_action_type: :property_show}), do: :property_index
  defp view_tab(%{live_action_type: live_action_type}), do: live_action_type

  defp get_property(%{live_action_type: :property_edit} = assigns) do
    %{properties: properties, params: %{"id" => str_id}} = assigns

    str_id
    |> String.to_integer()
    |> then(&Enum.find(properties, nil, fn item -> item.id == &1 end))
  end

  defp get_property(%{live_action_type: :property_show} = assigns) do
    %{properties: properties, params: %{"id" => str_id}} = assigns

    str_id
    |> String.to_integer()
    |> then(&Enum.find(properties, nil, fn item -> item.id == &1 end))
  end

  defp get_property(%{live_action_type: :property_new}), do: %Property{}
  defp get_property(%{live_action_type: _}), do: %Property{}
end
