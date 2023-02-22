defmodule RoomHere.ListingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RoomHere.Listings` context.
  """

  @doc """
  Generate a unique property slug.
  """
  def unique_property_slug, do: "some slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a property.
  """
  def property_fixture(attrs \\ %{}) do
    {:ok, property} =
      attrs
      |> Enum.into(%{
        description: "some description",
        first_available_date: ~N[2023-02-21 22:05:00],
        maximum_term: 42,
        minimum_term: 42,
        slug: unique_property_slug(),
        title: "some title"
      })
      |> RoomHere.Listings.create_property()

    property
  end
end
