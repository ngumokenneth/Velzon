defmodule Velzon.Repo.Migrations.CreateProductsTable do
  use Ecto.Migration

  def change do
    create table("products", primary_key: false) do
      add :product_id, :binary_id, primary_key: true
      add :name, :string
      add :product_description, :string
      add :product_meta, :map
      add :product_info, :map
      add :user_id, references("users", on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:products, [:user_id])
  end
end
