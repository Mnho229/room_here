defmodule RoomHere.Listings.PropertyTest do
  use RoomHere.DataCase

  alias RoomHere.Listings.Property

  describe "Property Changeset" do
    setup do
      :ok = Ecto.Adapters.SQL.Sandbox.checkout(RoomHere.Repo)
    end

    test "changeset success" do
      params = RoomHere.Factory.params_for(:property)

      changeset = Property.changeset(%Property{}, params)

      assert changeset.valid? == true
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
