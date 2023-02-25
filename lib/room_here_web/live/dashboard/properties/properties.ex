defmodule RoomHereWeb.Properties.MyProperties do
  use RoomHereWeb, :live_component

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def update(_assigns, socket) do
    {:ok, socket}
  end
end
