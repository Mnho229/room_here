defmodule RoomHere.Repo.Migrations.CreateProperties do
  use Ecto.Migration

  def change do
    create table(:properties) do
      add :title, :string
      add :minimum_term, :integer
      add :maximum_term, :integer
      add :description, :string
      add :first_available_date, :naive_datetime
      add :slug, :string

      timestamps()
    end

    create unique_index(:properties, [:slug])
  end
end
