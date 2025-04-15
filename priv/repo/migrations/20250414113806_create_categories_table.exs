defmodule Velzon.Repo.Migrations.CreateCategoriesTable do
  use Ecto.Migration

  def change do
    create table("categories", primary_key: false) do
      add :category_id, :binary_id, primary_key: true
      add :title, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:categories, [:title])
  end
end
