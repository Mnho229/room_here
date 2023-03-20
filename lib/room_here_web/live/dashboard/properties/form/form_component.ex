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

  # TODO: Block Save button when changeset is not valid
  def handle_event("save", %{"property" => property_params}, socket) do
    with %{property: property, user: user, action: action} <- socket.assigns,
         %Ecto.Changeset{valid?: true} = changeset <-
           Listings.change_property(property, property_params),
         {:ok, _result} <- Listings.upsert_property(user, action, changeset) do
      send(self(), :new_or_updated_property)
      {:noreply, socket}
    else
      bad_result ->
        IO.inspect(bad_result, label: "Some error")
        {:noreply, socket}
    end
  end
end
