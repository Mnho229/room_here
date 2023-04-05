defmodule RoomHereWeb.Properties.IndexTest do
  use RoomHereWeb.ConnCase

  import Phoenix.LiveViewTest

  setup %{conn: conn} do
    user = RoomHere.Factory.insert(:user)

    %{conn: log_in_user(conn, user), user: user}
  end

  describe "Properties Index" do
    test "page is live", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/dashboard/properties")

      assert html =~ "Properties Connected to you"
    end

    setup %{user: user} do
      primary_property_users = RoomHere.Factory.insert_pair(:property_user_primary, user: user)
      not_primary_property_users = RoomHere.Factory.insert_pair(:property_user, user: user)

      pusers = primary_property_users ++ not_primary_property_users

      properties = Enum.map(pusers, & &1.property)

      %{properties: properties}
    end

    test "Page shows properties associated with logged in user", %{
      conn: conn
    } do
      {:ok, _view, html} = live(conn, "/dashboard/properties")

      assert html =~ "This is an accurate retelling of how bad Honorius was"

      assert count_occurences_by_element_text(html, "a", "View") == 4
      assert count_occurences_by_element_text(html, "a", "Edit") == 2
    end
  end
end
