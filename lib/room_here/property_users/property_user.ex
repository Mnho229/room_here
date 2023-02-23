defmodule RoomHere.PropertyUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias RoomHere.{Accounts, Listings}

  schema "property_users" do
    field :is_primary_user?, :boolean

    belongs_to :users, Accounts.User
    belongs_to :properties, Listings.Property

    timestamps()
  end

  def changeset(property_user, attrs) do
    property_user
    |> cast(attrs, [:is_primary_user?, :user_id, :property_id])
    |> unique_constraint([:user_id, :property_id], name: :unique_property_user)
  end
end
