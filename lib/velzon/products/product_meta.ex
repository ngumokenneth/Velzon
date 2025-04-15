defmodule Velzon.Products.ProductMeta do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :title, :string
    field :keywords, :string
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(%__MODULE__{} = product_meta, attrs \\ %{}) do
    product_meta
    |> cast(attrs, [:title, :keywords, :description])
    |> validate_required([:title, :keywords, :description])
  end
end
