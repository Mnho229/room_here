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

  @default_attrs ~w(title minimum_term maximum_term description first_available_date slug)a

  @doc false
  def changeset(property, attrs) do
    property
    |> cast(attrs, @default_attrs)
    |> validate_required([
      :title,
      :minimum_term,
      :maximum_term,
      :description,
      :first_available_date
    ])
    |> validate_number(:minimum_term, less_than: attrs.maximum_term)
    |> unique_constraint(:slug)
  end
end
