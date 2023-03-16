defmodule RoomHereWeb.DashboardLive.DashboardComponents do
  use RoomHereWeb, :component

  attr :target, :map, required: true

  def property_modal(assigns) do
    ~H"""
    <.modal max_width="xl" title="Modal" close_modal_target={@target}>
      <.p>Content</.p>

      <div class="flex justify-end">
        <.button label="close" phx-click={PetalComponents.Modal.hide_modal(@target)} />
      </div>
    </.modal>
    """
  end
end
