defmodule RoomHere.Repo.Migrations.ChangePropertyDescriptionToText do
  use Ecto.Migration

  def change do
    alter table(:properties) do
      modify :description, :text, from: :string
    end
  end
end
