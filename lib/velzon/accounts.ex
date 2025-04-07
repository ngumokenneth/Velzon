defmodule Velzon.Accounts do
  @moduledoc """
  Context file for working with accounts
  """

  alias Velzon.Accounts.User
  # alias Velzon.Accounts.User.CreateUser
  alias Velzon.Repo

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.creation_changeset(attrs)
    |> Repo.insert()
  end

  def change_user(user \\ %User{}, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def get_user(id) do
    Repo.get!(%User{}, id)
  end
end
