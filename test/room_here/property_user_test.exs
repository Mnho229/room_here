defmodule RoomHere.PropertyUserTest do
  use RoomHere.DataCase

  alias RoomHere.PropertyUser

  describe "property user changeset" do
    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(RoomHere.Repo)
      property = RoomHere.Factory.insert(:property)
      user = RoomHere.Factory.insert(:user)

      %{
        property: property,
        user: user
      }
    end

    test "changeset success on create", %{property: property, user: user} do
      params =
        RoomHere.Factory.params_with_assocs(:property_user_primary, property: property, user: user)

      changeset = PropertyUser.changeset(%PropertyUser{}, params)

      assert changeset.valid? == true
    end

    test "changeset failure on lacking property", %{user: user} do
      params = RoomHere.Factory.params_with_assocs(:property_user_primary, user: user)

      changeset_errors =
        %PropertyUser{}
        |> PropertyUser.changeset(params)
        |> errors_on()

      assert changeset_errors.property_id == ["can't be blank"]
    end

    test "changeset failure on lacking user", %{property: property} do
      params =
        :property_user_primary
        |> RoomHere.Factory.params_with_assocs(property: property)
        |> Map.delete(:user_id)

      changeset_errors =
        %PropertyUser{}
        |> PropertyUser.changeset(params)
        |> errors_on()

      assert changeset_errors.user_id == ["can't be blank"]
    end

    test "changeset failure on unique constraint for user and property", %{
      property: property,
      user: user
    } do
      property_user =
        RoomHere.Factory.insert(:property_user_primary, property: property, user: user)

      params = %{
        is_primary_user: false,
        property_id: property_user.property_id,
        user_id: property_user.user_id
      }

      changeset_errors =
        %PropertyUser{}
        |> PropertyUser.changeset(params)
        |> RoomHere.Repo.insert()
        |> elem(1)
        |> errors_on()

      assert changeset_errors.user_id == ["has already been taken"]
    end

    test "changeset failure on unique constraint for is_primary_user and property", %{
      property: property,
      user: user
    } do
      property_user = RoomHere.Factory.insert(:property_user_primary, property: property)

      params = %{
        is_primary_user: true,
        property_id: property_user.property_id,
        user_id: user.id
      }

      changeset_errors =
        %PropertyUser{}
        |> PropertyUser.changeset(params)
        |> RoomHere.Repo.insert()
        |> elem(1)
        |> errors_on()

      assert changeset_errors[:is_primary_user] == ["has already been taken"]
    end
  end
end
