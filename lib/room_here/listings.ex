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
  @spec list_properties() :: [%Property{}]
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
  @spec get_property!(integer()) :: %Property{} | no_return()
  def get_property!(id), do: Repo.get!(Property, id)

  @doc """
  Creates a property.

  ## Examples

      iex> create_property(%{field: value})
      {:ok, %Property{}}

      iex> create_property(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # TODO: Feed into Upsert with global staff user
  def create_property(attrs \\ %{}) do
    %Property{}
    |> Map.put(:slug, generate_property_slug())
    |> Property.changeset(attrs)
    |> Repo.insert()
  end

  # Restrict to only related users
  @spec upsert_property(%User{}, :create | :update, Ecto.Changeset.t()) ::
          {:ok, %Property{}} | {:error, any()}
  def upsert_property(%User{} = user, action, %Ecto.Changeset{} = changeset) do
    changeset
    |> Ecto.Changeset.put_change(:slug, generate_property_slug())
    |> store_property(action, user)
  end

  @doc """
  Updates a property.

  ## Examples

      iex> update_property(property, %{field: new_value})
      {:ok, %Property{}}

      iex> update_property(property, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_property(%Property{}, map()) :: {:ok, any()} | {:error, any()}
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
  @spec delete_property(%Property{}) :: {:ok, %Property{}} | {:error, %Ecto.Changeset{}}
  def delete_property(%Property{} = property) do
    Repo.delete(property)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking property changes.

  ## Examples

      iex> change_property(property)
      %Ecto.Changeset{data: %Property{}}

  """
  @spec change_property(%Property{}, map()) :: %Ecto.Changeset{}
  def change_property(%Property{} = property, attrs \\ %{}) do
    Property.changeset(property, attrs)
  end

  @spec list_properties_with_user(%User{}) :: [%Property{}]
  def list_properties_with_user(user) do
    Property.Query.base()
    |> Property.Query.for_user(user)
    |> Repo.all()
  end

  @spec store_property(%Ecto.Changeset{}, atom(), %User{}) :: {:ok, any()} | {:error, any()}
  defp store_property(%Ecto.Changeset{} = changeset, action, %User{} = user) do
    Multi.new()
    |> Multi.insert_or_update(:property, changeset)
    |> maybe_create_primary_property_user(action, user)
    |> Repo.transaction()
  end

  @spec maybe_create_primary_property_user(%Multi{}, atom(), %User{}) ::
          %Multi{names: %{property_user: %Ecto.Changeset{}}} | %Multi{}
  defp maybe_create_primary_property_user(%Multi{} = multi, :create, user) do
    Multi.insert(multi, :property_user, fn %{property: property} ->
      attrs = %{property: property, user: user, is_primary_user: true}
      PropertyUser.changeset(%PropertyUser{}, attrs)
    end)
  end

  defp maybe_create_primary_property_user(multi, :update, _) do
    multi
  end

  @spec generate_property_slug() :: String.t()
  defp generate_property_slug do
    :crypto.strong_rand_bytes(16)
    |> Base.url_encode64()
    |> binary_part(0, 16)
  end
end
