defmodule RoomHereWeb.DashboardLiveSessionTest do
  use RoomHereWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "Accessing Dashboard" do
    test "successful access", %{conn: conn} do
      user = RoomHere.Factory.insert(:user)

      conn = log_in_user(conn, user)

      conn = get(conn, "/dashboard")
      {:ok, _view, html} = live(conn, "/dashboard")

      assert Map.has_key?(conn.assigns, :current_user)
      assert html =~ "The real place to be"
    end

    test "failure to access by not being logged in", %{conn: conn} do
      assert {:error, {:redirect, %{to: "/users/log_in"}}} = live(conn, "/dashboard")
    end
  end
end
