defmodule RoomHere.Repo.Migrations.AddPropertyUserTable do
  use Ecto.Migration

  def change do
    create table("property_users") do
      add :is_primary_user, :boolean, null: false, default: false

      add :user_id, references("users"), null: false
      add :property_id, references("properties"), null: false

      timestamps()
    end

    create index("property_users", :user_id)
    create index("property_users", :property_id)

    create index("property_users", [:is_primary_user, :property_id],
             unique: true,
             where: "is_primary_user = true",
             name: :unique_primary_user_for_property
           )

    create unique_index("property_users", [:user_id, :property_id], name: :unique_property_user)
  end
end
