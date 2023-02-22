defmodule RoomHere.ListingsTest do
  use RoomHere.DataCase

  alias RoomHere.Listings

  describe "properties" do
    alias RoomHere.Listings.Property

    import RoomHere.ListingsFixtures

    @invalid_attrs %{description: nil, first_available_date: nil, maximum_term: nil, minimum_term: nil, slug: nil, title: nil}

    test "list_properties/0 returns all properties" do
      property = property_fixture()
      assert Listings.list_properties() == [property]
    end

    test "get_property!/1 returns the property with given id" do
      property = property_fixture()
      assert Listings.get_property!(property.id) == property
    end

    test "create_property/1 with valid data creates a property" do
      valid_attrs = %{description: "some description", first_available_date: ~N[2023-02-21 22:05:00], maximum_term: 42, minimum_term: 42, slug: "some slug", title: "some title"}

      assert {:ok, %Property{} = property} = Listings.create_property(valid_attrs)
      assert property.description == "some description"
      assert property.first_available_date == ~N[2023-02-21 22:05:00]
      assert property.maximum_term == 42
      assert property.minimum_term == 42
      assert property.slug == "some slug"
      assert property.title == "some title"
    end

    test "create_property/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Listings.create_property(@invalid_attrs)
    end

    test "update_property/2 with valid data updates the property" do
      property = property_fixture()
      update_attrs = %{description: "some updated description", first_available_date: ~N[2023-02-22 22:05:00], maximum_term: 43, minimum_term: 43, slug: "some updated slug", title: "some updated title"}

      assert {:ok, %Property{} = property} = Listings.update_property(property, update_attrs)
      assert property.description == "some updated description"
      assert property.first_available_date == ~N[2023-02-22 22:05:00]
      assert property.maximum_term == 43
      assert property.minimum_term == 43
      assert property.slug == "some updated slug"
      assert property.title == "some updated title"
    end

    test "update_property/2 with invalid data returns error changeset" do
      property = property_fixture()
      assert {:error, %Ecto.Changeset{}} = Listings.update_property(property, @invalid_attrs)
      assert property == Listings.get_property!(property.id)
    end

    test "delete_property/1 deletes the property" do
      property = property_fixture()
      assert {:ok, %Property{}} = Listings.delete_property(property)
      assert_raise Ecto.NoResultsError, fn -> Listings.get_property!(property.id) end
    end

    test "change_property/1 returns a property changeset" do
      property = property_fixture()
      assert %Ecto.Changeset{} = Listings.change_property(property)
    end
  end
end
