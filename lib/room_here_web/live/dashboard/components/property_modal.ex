defmodule RoomHereWeb.DashboardLive.DashboardComponents do
  use RoomHereWeb, :component

  attr :target, :map, required: true
  attr :property, :map

  def property_modal(assigns) do
    ~H"""
    <.modal max_width="lg" title="Modal" close_modal_target={@target}>
      <%!-- Make this cleaner somehow --%>
      <%= if is_nil(@property) do %>
        <.p>Nobody here but us trees!</.p>
      <% else %>
        <ul class="text-white">
          <li><%= @property.title %></li>
          <li><%= @property.description %></li>
          <li><%= @property.minimum_term %></li>
          <li><%= @property.maximum_term %></li>
          <li><%= @property.first_available_date %></li>
        </ul>
      <% end %>

      <div class="flex justify-end">
        <.button label="Close" phx-click={PetalComponents.Modal.hide_modal(@target)} />
      </div>
    </.modal>
    """
  end
end
