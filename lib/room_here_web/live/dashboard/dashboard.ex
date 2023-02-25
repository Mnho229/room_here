defmodule RoomHereWeb.Dashboard do
  use RoomHereWeb, :live_user_dashboard

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
