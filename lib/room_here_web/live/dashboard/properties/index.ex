defmodule RoomHereWeb.Properties.Index do
  use RoomHereWeb, :live_component

  alias RoomHere.Listings
  alias RoomHere.Listings.Property
  alias RoomHere.PropertyUser

  import RoomHereWeb.PropertyComponents

  @property_tabs [
    {:property_index, "Index"},
    {:property_new, "New Property"}
  ]

  def mount(socket) do
    {:ok, socket}
  end

  def preload([assigns]) do
    properties = Listings.list_properties_with_user(assigns.user)

    %{
      primary: primary_properties,
      non_primary: non_primary_properties
    } = separate_properties_by_primary(properties, assigns.user)

    assigns =
      assigns
      |> Map.put(:property, get_property(assigns, properties))
      |> Map.put(:nav_list, @property_tabs)
      |> Map.put(:primary_properties, primary_properties)
      |> Map.put(:non_primary_properties, non_primary_properties)

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

  # -------------------------------------------------

  defp separate_properties_by_primary(properties, user) do
    Enum.reduce(properties, %{primary: [], non_primary: []}, fn property, acc ->
      case get_attached_property_user_from_property(user, property) do
        %PropertyUser{is_primary_user: true} ->
          %{acc | primary: [property | acc.primary]}

        %PropertyUser{is_primary_user: false} ->
          %{acc | non_primary: [property | acc.non_primary]}
      end
    end)
  end

  defp get_attached_property_user_from_property(user, property) do
    Enum.find(property.property_users, &(&1.user_id == user.id))
  end

  defp view_tab(%{live_action_type: :property_show}), do: :property_index
  defp view_tab(%{live_action_type: live_action_type}), do: live_action_type

  defp get_property(%{live_action_type: :property_new}, _), do: %Property{}

  defp get_property(%{live_action_type: live_action_type} = assigns, properties)
       when live_action_type in [:property_edit, :property_show] do
    %{params: %{"id" => str_id}} = assigns

    str_id
    |> String.to_integer()
    |> then(&Enum.find(properties, nil, fn item -> item.id == &1 end))
  end

  defp get_property(%{live_action_type: _}, _), do: %Property{}
end
