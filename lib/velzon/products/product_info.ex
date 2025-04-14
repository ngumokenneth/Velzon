defmodule Velzon.Products.ProductInfo do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :manufacturer, :string
    field :brand, :string
    field :stocks, :integer
    field :price, :decimal
    field :discount, :decimal
    field :orders, :integer

    timestamps(type: :utc_datetime)
  end
  def changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:manufacturer, :brand, :stocks, :price, :discount, :orders])
    |> validate_required([:manufacturer, :brand, :stocks, :price, :discount, :orders])
  end
end
