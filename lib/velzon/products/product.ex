defmodule Velzon.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  # alias Velzon.Accounts.User
  alias Velzon.Products.ProductInfo
  alias Velzon.Products.ProductMeta

  @primary_key {:product_id, :binary_id, autogenerate: true}
  schema "products" do
    field :name, :string
    field :product_description, :string
    embeds_one(:product_info, ProductInfo, on_replace: :update)
    embeds_one(:product_meta, ProductMeta, on_replace: :update)

    many_to_many(:categories, Velzon.Products.Category,
      join_through: "product_categories",
      join_keys: [product_id: :product_id, category_id: :category_id],
      on_delete: :delete_all
    )

    timestamps(type: :utc_datetime)
  end

  def changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:name, :product_description])
    |> validate_required([:name, :product_description])
    |> cast_embed(:product_info, with: &ProductInfo.changeset/1, required: true)
    |> cast_embed(:product_meta, with: &ProductMeta.changeset/1, required: true)
  end
end
