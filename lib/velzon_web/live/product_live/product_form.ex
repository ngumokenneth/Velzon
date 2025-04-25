defmodule VelzonWeb.ProductLive.ProductForm do
  use Ecto.Schema
  import Ecto.Changeset

  alias Velzon.Accounts.User
  alias Velzon.Products.Product
  alias VelzonWeb.ProductLive.ProductForm

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

    belongs_to :user, User

    timestamps()
  end

  def new(product \\ %ProductForm{}) do
    product
    |> changeset(%{})
  end

  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :product_description])
    |> validate_required([:name, :product_description])
    |> cast_embed(:product_info, with: &product_info_changeset/2)
    |> cast_embed(:product_meta, with: &product_meta_changeset/2)
  end

  def product_meta_changeset(product_meta, attrs \\ %{}) do
    product_meta
    |> cast(attrs, [:title, :keywords, :description])
    |> validate_required([:title, :keywords, :description])
  end

  def product_info_changeset(product_info, attrs \\ %{}) do
    product_info
    |> cast(attrs, [:manufacturer, :brand, :stocks, :price, :discount, :orders])
    |> validate_required([:manufacturer, :brand, :stocks, :price, :discount, :orders])
  end

  def validate(%Phoenix.HTML.Form{} = form, params) do
    form.source.data
    |> changeset(params)
    |> Map.put(:action, :validate)
  end

  def submit(%Phoenix.HTML.Form{} = form, params) do
    form.source.data
    |> changeset(params)
    |> apply_action(:insert)
  end

  def form_submit(form, params) do
    form
    |> submit(params)
    |> format_result()
  end

  def format_result({:ok, data}) do
    output = %{
      product: %{
        name: data.name,
        product_description: data.product_description,
        product_info: Map.from_struct(data.product_info),
        product_meta: Map.from_struct(data.product_meta)
      }
    }

    {:ok, output}
  end

  def to_product_changeset(%ProductForm{} = form_data) do
    %Velzon.Products.Product{}
    |> Product.changeset(Map.from_struct(form_data))
  end
end
