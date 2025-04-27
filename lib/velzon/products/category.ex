defmodule Velzon.Products.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:category_id, :binary_id, autogenerate: true}
  schema "categories" do
    field :title, :string

    many_to_many(:products, Velzon.Products.Product,
      join_through: "product_categories",
      join_keys: [category_id: :category_id, product_id: :product_id],
      on_delete: :delete_all
    )

    timestamps(type: :utc_datetime)
  end

  def changeset(category \\ %__MODULE__{}, attrs \\ %{}) do
    category
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> unique_constraint([:title])
  end
end
