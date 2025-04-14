defmodule Velzon.Products.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :title, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> unique_constraint([:title])
  end
end
