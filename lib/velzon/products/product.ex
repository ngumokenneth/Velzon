defmodule Velzon.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  # alias Velzon.Accounts.User
  alias Velzon.Products.ProductInfo
  alias Velzon.Products.ProductMeta

  @default_attrs %{
    name: "",
    product_description: "",
    product_info: Map.from_struct(%ProductInfo{}),
    product_meta: Map.from_struct(%ProductMeta{})
  }

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

  def new(product \\ %__MODULE__{}) do
    changeset(product, @default_attrs)
  end

  def changeset(%__MODULE__{} = product, attrs \\ %{}) do
    product
    |> cast(attrs, [:name, :product_description])
    |> validate_required([:name, :product_description])
    |> cast_embed(:product_info, with: &ProductInfo.changeset/2, required: true)
    |> cast_embed(:product_meta, with: &ProductMeta.changeset/2, required: true)
  end
end
