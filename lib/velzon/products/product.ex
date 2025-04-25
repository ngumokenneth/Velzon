defmodule Velzon.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias Velzon.Accounts.User

  @primary_key {:product_id, :binary_id, autogenerate: true}
  schema "products" do
    field :name, :string
    field :product_description, :string

    embeds_one :product_info, ProductInfo, on_replace: :update, primary_key: false do
      field :manufacturer, :string
      field :brand, :string
      field :stocks, :integer
      field :price, :decimal
      field :discount, :decimal
      field :orders, :integer
    end

    embeds_one :product_meta, ProductMeta, on_replace: :update, primary_key: false do
      field :title, :string
      field :keywords, :string
      field :description, :string
    end

    many_to_many(:categories, Velzon.Products.Category,
      join_through: "product_categories",
      join_keys: [product_id: :product_id, category_id: :category_id],
      on_delete: :delete_all
    )

    belongs_to :user, User

    timestamps()
  end

  def changeset(product, attrs, user \\ nil) do
    product
    |> cast(attrs, [:name, :product_description])
    |> cast_embed(:product_info, with: &product_info_changeset/2, required: true)
    |> cast_embed(:product_meta, with: &product_meta_changeset/2, required: true)
    |> validate_required([:name, :product_description])
    |> put_assoc(:user, user)
  end

  defp product_info_changeset(product_info, attrs) do
    product_info
    |> cast(attrs, [:manufacturer, :brand, :stocks, :price, :discount, :orders])
    |> validate_required([:manufacturer, :brand, :stocks, :price, :discount, :orders])
  end

  defp product_meta_changeset(product_meta, attrs) do
    product_meta
    |> cast(attrs, [:title, :keywords, :description])
    |> validate_required([:title, :keywords, :description])
  end
end
