defmodule RoomHereWeb.Properties.FormComponent do
  use RoomHereWeb, :live_component

  alias RoomHere.Listings
  alias RoomHere.Listings.Property

  def update(assigns, socket) do
    changeset = Listings.change_property(%Property{})

    socket =
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)

    {:ok, socket}
  end

  def handle_event("validate", %{"property" => property_params} = _params, socket) do
    changeset = Listings.change_property(%Property{}, property_params)

    IO.inspect(changeset, label: "Changeset")

    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    IO.inspect("You have made it to to the save screen")

    {:noreply, socket}
  end
end
