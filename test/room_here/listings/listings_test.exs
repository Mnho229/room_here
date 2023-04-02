defmodule RoomHere.ListingsTest do
  use RoomHere.DataCase

  alias RoomHere.Listings

  describe "properties" do
    alias RoomHere.Listings.Property

    import RoomHere.ListingsFixtures

    @invalid_attrs %{
      description: nil,
      first_available_date: nil,
      maximum_term: nil,
      minimum_term: nil,
      slug: nil,
      title: nil
    }

    test "list_properties/0 returns all properties" do
      property = RoomHere.Factory.insert(:property)
      assert Listings.list_properties() == [property]
    end

    test "get_property!/1 returns the property with given id" do
      property = RoomHere.Factory.insert(:property)
      assert Listings.get_property!(property.id) == property
    end

    test "create_property/1 with valid data creates a property" do
      attrs = RoomHere.Factory.params_for(:property)

      assert {:ok, %Property{} = property} = Listings.create_property(attrs)
      assert property.description == attrs.description
      assert property.first_available_date == attrs.first_available_date
      assert property.maximum_term == attrs.maximum_term
      assert property.minimum_term == attrs.minimum_term
      assert property.slug == attrs.slug
      assert property.title == attrs.title
    end

    test "create_property/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Listings.create_property(@invalid_attrs)
    end

    test "update_property/2 with valid data updates the property" do
      property = RoomHere.Factory.insert(:property)

      attrs = %{
        description: "some updated description",
        first_available_date: ~N[2023-02-22 22:05:00],
        maximum_term: property.maximum_term,
        minimum_term: property.minimum_term,
        slug: property.slug,
        title: property.title
      }

      assert {:ok, %Property{} = property} = Listings.update_property(property, attrs)
      assert property.description == "some updated description"
      assert property.first_available_date == ~N[2023-02-22 22:05:00]
      assert property.maximum_term == attrs.maximum_term
      assert property.minimum_term == attrs.minimum_term
      assert property.slug == attrs.slug
      assert property.title == attrs.title
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

  describe "Custom Listings functions" do
    test "list_properties_with_user/1" do
      %{user: user} = RoomHere.Factory.insert(:property_user_primary)
      RoomHere.Factory.insert_list(3, :property_user_primary, user: user)

      assert length(Listings.list_properties_with_user(user)) == 4
    end
  end
end
