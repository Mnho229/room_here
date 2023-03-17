defmodule RoomHere.Listings do
  @moduledoc """
  The Listings context.
  """

  import Ecto.Query, warn: false
  alias RoomHere.Repo
  alias Ecto.Multi

  alias RoomHere.Listings.Property
  alias RoomHere.Accounts.User
  alias RoomHere.PropertyUser

  @doc """
  Returns the list of properties.

  ## Examples

      iex> list_properties()
      [%Property{}, ...]

  """
  def list_properties do
    Repo.all(Property)
  end

  @doc """
  Gets a single property.

  Raises `Ecto.NoResultsError` if the Property does not exist.

  ## Examples

      iex> get_property!(123)
      %Property{}

      iex> get_property!(456)
      ** (Ecto.NoResultsError)

  """
  def get_property!(id), do: Repo.get!(Property, id)

  @doc """
  Creates a property.

  ## Examples

      iex> create_property(%{field: value})
      {:ok, %Property{}}

      iex> create_property(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_property(attrs \\ %{}) do
    %Property{}
    |> Map.put(:slug, generate_property_slug())
    |> Property.changeset(attrs)
    |> Repo.insert()
  end

  # Restrict to only related users
  def create_property(%User{} = user, %Ecto.Changeset{} = changeset) do
    changeset
    |> Ecto.Changeset.put_change(:slug, generate_property_slug())
    |> store_property(user)
  end

  defp store_property(%Ecto.Changeset{} = changeset, %User{} = user) do
    Multi.new()
    |> Multi.insert(:property, changeset)
    |> Multi.insert(:property_user, fn %{property: property} ->
      attrs = %{property: property, user: user, is_primary_user: true}
      PropertyUser.changeset(%PropertyUser{}, attrs)
    end)
    |> Repo.transaction()
  end

  @doc """
  Updates a property.

  ## Examples

      iex> update_property(property, %{field: new_value})
      {:ok, %Property{}}

      iex> update_property(property, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_property(%Property{} = property, attrs) do
    property
    |> Property.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a property.

  ## Examples

      iex> delete_property(property)
      {:ok, %Property{}}

      iex> delete_property(property)
      {:error, %Ecto.Changeset{}}

  """
  def delete_property(%Property{} = property) do
    Repo.delete(property)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking property changes.

  ## Examples

      iex> change_property(property)
      %Ecto.Changeset{data: %Property{}}

  """
  def change_property(%Property{} = property, attrs \\ %{}) do
    Property.changeset(property, attrs)
  end

  def list_properties_with_user(user) do
    Property.Query.base()
    |> Property.Query.for_user(user)
    |> Repo.all()
  end

  defp generate_property_slug do
    :crypto.strong_rand_bytes(16)
    |> Base.url_encode64()
    |> binary_part(0, 16)
  end
end
