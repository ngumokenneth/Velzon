defmodule Velzon.Products do
  import Ecto.Query
  # import Ecto.Changeset

  alias Velzon.Repo

  alias Velzon.Products.Category
  alias Velzon.Products.Product

  # def create_product(%Product{} = product, attrs) do
  #   changeset = Product.changeset(product, attrs)
  #   Repo.insert(changeset)
  # end

  def create_product(attrs \\ %{}, user) do
    %Product{}
    |> Product.changeset(attrs, user)
    |> Repo.insert()
  end

  def get_product!(id) do
    Product |> Repo.get!(id) |> Repo.preload(:categories)
  end

  # def change_product(product \\ %Product{}, attrs \\ %{}) do
  #   categories = list_categories_by_id(attrs["categories_ids"])

  #   product
  #   |> Repo.preload(:categories)
  #   |> Product.new()
  #   |> Ecto.Changeset.put_assoc(:categories, categories)
  # end

  def list_categories_by_id(nil), do: []

  def list_categories_by_id(category_ids) do
    categories = from c in Category, where: c.category_id == ^category_ids
    Repo.all(categories)
  end

  def validate(%Phoenix.HTML.Form{} = form, attrs) do
    form.source.data
    |> Product.changeset(attrs)
    |> Map.put(:action, :validate)
  end

  # def submit(%Phoenix.HTML.Form{} = form, attrs) do
  #   form.source.data
  #   |> create_product(attrs)
  #   |> Ecto.Changeset.apply_action(:insert)
  # end
end
