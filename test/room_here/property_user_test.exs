defmodule RoomHere.PropertyUserTest do
  use RoomHere.DataCase, async: false

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

    test "success on first user", %{property: property, user: user} do
      params =
        RoomHere.Factory.params_with_assocs(:property_user_primary, property: property, user: user)

      changeset = PropertyUser.changeset(%PropertyUser{}, params)

      assert changeset.valid? == true
    end

    test "success on subsequent property users", %{property: property, user: user} do
      RoomHere.Factory.insert(:property_user_primary, property: property)

      params = RoomHere.Factory.params_with_assocs(:property_user, property: property, user: user)

      new_property_user =
        %PropertyUser{}
        |> RoomHere.PropertyUser.changeset(params)
        |> Repo.insert!()

      assert new_property_user.user_id == user.id
      assert new_property_user.property_id == property.id

      property =
        RoomHere.Listings.Property
        |> RoomHere.Repo.get!(property.id)
        |> RoomHere.Repo.preload(:property_users)

      assert length(property.property_users) == 2
    end

    test "failure on lacking property", %{user: user} do
      params = RoomHere.Factory.params_with_assocs(:property_user_primary, user: user)

      changeset_errors =
        %PropertyUser{}
        |> PropertyUser.changeset(params)
        |> errors_on()

      assert changeset_errors.property_id == ["can't be blank"]
    end

    test "failure on lacking user", %{property: property} do
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

    test "failure on unique constraint for user and property", %{
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

    test "failure on unique constraint for is_primary_user and property", %{
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

    test "failure on foreign key constraint for user_id", %{property: property} do
      params =
        :property_user_primary
        |> RoomHere.Factory.params_with_assocs(property: property)
        |> Map.put(:user_id, 9029)

      changeset_errors =
        %PropertyUser{}
        |> PropertyUser.changeset(params)
        |> RoomHere.Repo.insert()
        |> elem(1)
        |> errors_on()

      assert changeset_errors[:user_id] == ["does not exist"]
    end

    test "failure on foreign key constraint for property_id" do
      params =
        :property_user_primary
        |> RoomHere.Factory.params_with_assocs()
        |> Map.put(:property_id, 9029)

      changeset_errors =
        %PropertyUser{}
        |> PropertyUser.changeset(params)
        |> RoomHere.Repo.insert()
        |> elem(1)
        |> errors_on()

      assert changeset_errors[:property_id] == ["does not exist"]
    end
  end
end
