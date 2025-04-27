defmodule Velzon.Products do
  import Ecto.Query
  # import Ecto.Changeset

  alias Velzon.Repo

  alias Velzon.Products.Category
  alias Velzon.Products.Product
  alias Velzon.Accounts.User

  def create_product(attrs \\ %{}, %User{} = user) do
    %Product{}
    |> change_product(attrs, user)
    |> Repo.insert()
    |> case do
      {:ok, product} -> {:ok, :created, product}
      {:error, changeset} -> {:error, :form, changeset}
    end
  end

  def get_product!(id) do
    Product |> Repo.get!(id) |> Repo.preload(:categories)
  end

  def change_product(%Product{} = product, attrs \\ %{}, user) do
    categories = list_categories_by_id(attrs["categories_ids"])

    product
    |> Repo.preload(:categories)
    |> Product.changeset(attrs, user)
    |> Ecto.Changeset.put_assoc(:categories, categories)
  end

  def update_product(%Product{} = product, attrs, user) do
    product
    |> change_product(attrs, user)
    |> Repo.update()
    |> case do
      {:ok, product} -> {:ok, :updated, product}
      {:error, changeset} -> {:error, :form, changeset}
    end
  end

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

end
