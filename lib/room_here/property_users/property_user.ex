defmodule RoomHere.PropertyUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias RoomHere.{Accounts, Listings}

  schema "property_users" do
    field :is_primary_user, :boolean, default: false

    belongs_to :user, Accounts.User
    belongs_to :property, Listings.Property

    timestamps()
  end

  def changeset(property_user, attrs) do
    property_user
    |> cast(attrs, [:is_primary_user])
    |> put_assoc(:property, attrs.property)
    |> put_assoc(:user, attrs.user)
    |> unique_constraint([:user_id, :property_id], name: :unique_property_user)
    |> unique_constraint([:is_primary_user, :property_id], name: :unique_primary_user_for_property)
  end

  # TODO: changesets for adding a user to property and removing a user
  # TODO: Also don't forget is_primary_user promotion
end
