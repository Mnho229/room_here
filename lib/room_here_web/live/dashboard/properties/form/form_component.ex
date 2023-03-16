defmodule RoomHereWeb.Properties.FormComponent do
  use RoomHereWeb, :live_component

  alias RoomHere.Listings

  def update(assigns, socket) do
    changeset = Listings.change_property(assigns.property)

    socket =
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)

    {:ok, socket}
  end

  def handle_event("validate", %{"property" => property_params} = _params, socket) do
    %{assigns: %{property: property}} = socket

    changeset =
      Listings.change_property(property, property_params)
      |> Map.put(:action, :validate)
      |> IO.inspect()

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", _params, socket) do
    IO.inspect("You have made it to to the save screen")

    {:noreply, socket}
  end
end
