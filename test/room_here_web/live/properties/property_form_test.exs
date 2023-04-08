defmodule RoomHereWeb.PropertyFormComponentTest do
  use RoomHereWeb.ConnCase

  import Phoenix.LiveViewTest

  setup %{conn: conn} do
    user = RoomHere.Factory.insert(:user)

    %{conn: log_in_user(conn, user), user: user}
  end

  describe "New Property" do
    test "page is live", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/dashboard/properties/new")

      assert html =~ "Enter first available date here"
    end
  end
end
