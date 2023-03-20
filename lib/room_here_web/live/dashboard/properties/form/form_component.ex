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

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"property" => property_params}, socket) do
    with %{property: property, user: user, action: action} <- socket.assigns,
         %Ecto.Changeset{valid?: true} = changeset <-
           Listings.change_property(property, property_params),
         {:ok, _result} <- Listings.upsert_property(user, action, changeset) do
      send(self(), {:property_form, :success})
      {:noreply, socket}
    else
      _bad_result ->
        send(self(), {:property_form, :failure})
        {:noreply, socket}
    end
  end
end
