defmodule RoomHere.Listings.Property do
  use Ecto.Schema
  import Ecto.Changeset

  schema "properties" do
    field :description, :string
    field :first_available_date, :naive_datetime
    field :maximum_term, :integer
    field :minimum_term, :integer
    field :slug, :string
    field :title, :string

    has_many :property_users, RoomHere.PropertyUser

    timestamps()
  end

  # TODO: move slug creation to this core schema page
  # TODO: Add validation for minimum and maximum terms
  @doc false
  def changeset(property, attrs) do
    property
    |> cast(attrs, [
      :title,
      :minimum_term,
      :maximum_term,
      :description,
      :first_available_date,
      :slug
    ])
    |> validate_required([
      :title,
      :minimum_term,
      :maximum_term,
      :description,
      :first_available_date
    ])
    |> unique_constraint(:slug)
  end
end
