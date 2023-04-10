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

    test "form submission success", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/dashboard/properties/new")

      first_available_date = generate_form_friendly_first_available_date()

      params =
        RoomHere.Factory.string_params_for(
          :property,
          slug: nil,
          first_available_date: first_available_date
        )

      property_params = %{
        "property" => params
      }

      view
      |> element("#property_form")
      |> render_submit(property_params)

      :timer.sleep(2)

      assert assert_patch(view) == "/dashboard/properties"
      assert render(view) =~ first_available_date
    end

    test "form submission failure", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/dashboard/properties/new")

      first_available_date = generate_form_friendly_first_available_date()

      params =
        RoomHere.Factory.string_params_for(
          :property,
          slug: nil,
          first_available_date: first_available_date,
          minimum_term: -1
        )

      property_params = %{
        "property" => params
      }

      view
      |> element("#property_form")
      |> render_submit(property_params)

      :timer.sleep(2)

      rendered = render(view)
      assert rendered =~ "Something went wrong while saving."
      assert rendered =~ "Submit"
    end
  end
end
