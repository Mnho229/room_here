defmodule RoomHere.Listings.PropertyTest do
  use RoomHere.DataCase

  alias RoomHere.Listings.Property

  describe "Property Changeset" do
    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(RoomHere.Repo)
    end

    test "changeset success on create" do
      params = RoomHere.Factory.params_for(:property)

      changeset = Property.changeset(%Property{}, params)

      assert changeset.valid? == true
    end

    test "changeset success on update" do
      property = RoomHere.Factory.insert(:property)

      params = %{
        title: "Swab the poop deck!",
        minimum_term: property.minimum_term,
        maximum_term: property.maximum_term,
        description: property.description,
        first_available_date: property.first_available_date
      }

      new_property =
        property
        |> Property.changeset(params)
        |> RoomHere.Repo.update!()

      assert new_property.title == "Swab the poop deck!"
    end

    test "Changeset failure on validation" do
      params = RoomHere.Factory.params_for(:property, maximum_term: 1)

      changeset = Property.changeset(%Property{}, params)

      refute changeset.valid? == true
    end

    test "changeset failure on unique slug" do
      %{slug: slug} = RoomHere.Factory.insert(:property)

      params = RoomHere.Factory.params_for(:property, slug: slug)

      {:error, bad_changeset} = RoomHere.Listings.create_property(params)

      refute bad_changeset.valid? == true
    end
  end
end
