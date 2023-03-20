defmodule RoomHereWeb.PropertiesComponents do
  use RoomHereWeb, :component

  attr :properties, :list, required: true
  attr :title, :string, required: true
  attr :is_primary_user, :boolean, required: true

  def property_listings(assigns) do
    ~H"""
    <h3 class="text-2xl font-semibold mb-4"><%= @title %></h3>
    <section :for={property <- @properties}>
      <ul class="bg-white p-4 mb-4 border-solid border border-secondary-200">
        <li class="mb-2 text-lg"><%= property.title %></li>
        <li class="mb-1"><%= property.description %></li>
        <li><%= property.minimum_term %> months</li>
        <li class="mb-2"><%= property.maximum_term %> months</li>
        <li><%= property.first_available_date %></li>
        <li class="text-blue-600 flex justify-end space-x-2">
          <.button label="View" link_type="live_patch" to={~p"/dashboard/properties/#{property.id}"} />
          <.button
            :if={@is_primary_user}
            label="Edit"
            link_type="live_patch"
            to={~p"/dashboard/properties/#{property.id}/edit"}
          />
        </li>
      </ul>
    </section>
    """
  end

  attr :target, :map, required: true
  attr :property, :map

  def property_modal(assigns) do
    ~H"""
    <.modal max_width="lg" title="Modal" close_modal_target={@target}>
      <.p :if={is_nil(@property)}>Nobody here but us trees!</.p>
      <ul :if={!is_nil(@property)} class="text-white">
        <li><%= @property.title %></li>
        <li><%= @property.description %></li>
        <li><%= @property.minimum_term %></li>
        <li><%= @property.maximum_term %></li>
        <li><%= @property.first_available_date %></li>
      </ul>

      <div class="flex justify-end">
        <.button label="Close" phx-click={PetalComponents.Modal.hide_modal(@target)} />
      </div>
    </.modal>
    """
  end
end
