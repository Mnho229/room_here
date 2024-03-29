defmodule RoomHereWeb.DashboardLive do
  use RoomHereWeb, :live_user_dashboard

  @property_tabs [:property_index, :property_new, :property_show, :property_edit]

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

  @spec retrieve_tab_category(Phoenix.LiveView.Socket.t()) :: Phoenix.LiveView.Socket.t()
  defp retrieve_tab_category(%{assigns: %{live_action: live_action}} = socket) do
    cond do
      live_action in @property_tabs ->
        assign(socket, :category, :property)

      true ->
        assign(socket, :category, :not_implemented)
    end
  end

  # -------------------------------------

  def handle_info({:property_form, :success}, socket) do
    socket = put_flash(socket, :info, "This property has successfully been upserted.")

    {:noreply, push_patch(socket, to: "/dashboard/properties")}
  end

  def handle_info({:property_form, :failure}, socket) do
    {
      :noreply,
      put_flash(socket, :info, "Something went wrong while saving.  Please try again later.")
    }
  end
end
