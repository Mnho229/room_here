defmodule RoomHere.PropertyUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias RoomHere.{Accounts, Listings}

  schema "property_users" do
    field :is_primary_user, :boolean, default: false

    belongs_to :users, Accounts.User
    belongs_to :properties, Listings.Property

    timestamps()
  end

  def changeset(property_user, attrs) do
    property_user
    |> cast(attrs, [:is_primary_user, :user_id, :property_id])
    |> unique_constraint([:user_id, :property_id], name: :unique_property_user)
    |> unique_constraint([:is_primary_user, :property_id], name: :unique_primary_user_for_property)
  end
end
