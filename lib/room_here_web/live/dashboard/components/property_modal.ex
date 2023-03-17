defmodule RoomHereWeb.DashboardLive.DashboardComponents do
  use RoomHereWeb, :component

  attr :target, :map, required: true
  attr :property, :map

  def property_modal(assigns) do
    ~H"""
    <.modal max_width="lg" title="Modal" close_modal_target={@target}>
      <.p>Content</.p>
      <%!-- Make this cleaner somehow --%>
      <%= if is_nil(@property) do %>
        <.p>Nobody here but us trees!</.p>
      <% else %>
        <.p><%= @property.title %></.p>
      <% end %>

      <div class="flex justify-end">
        <.button label="close" phx-click={PetalComponents.Modal.hide_modal(@target)} />
      </div>
    </.modal>
    """
  end
end
