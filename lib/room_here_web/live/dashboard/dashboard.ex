defmodule RoomHereWeb.DashboardLive do
  use RoomHereWeb, :live_user_dashboard

  @property_tabs [:property_index, :property_new, :property_show]

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    socket =
      socket
      |> assign(:untreated_params, params)
      |> retrieve_tab_category()

    {:noreply, socket}
  end

  defp retrieve_tab_category(%{assigns: %{live_action: live_action}} = socket) do
    cond do
      live_action in @property_tabs ->
        assign(socket, :category, :property)

      true ->
        assign(socket, :category, :not_implemented)
    end
  end
end
