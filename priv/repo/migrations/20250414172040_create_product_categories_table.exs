defmodule Velzon.Repo.Migrations.CreateProductCategoriesTable do
  use Ecto.Migration

  def change do
    create table(:product_categories, primary_key: false) do
      add(
        :product_id,
        references(:products, column: :product_id, type: :binary_id, on_delete: :delete_all)
      )

      add(
        :category_id,
        references(:categories, column: :category_id, type: :binary_id, on_delete: :delete_all)
      )

      timestamps(type: :utc_datetime)
    end

    create index(:product_categories, [:product_id])
    create unique_index(:product_categories, [:category_id, :product_id])
  end
end
