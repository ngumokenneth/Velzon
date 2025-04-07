defmodule Velzon.Accounts.User.CreateUser do
  @doc """
  given the correct params, it creates a new user
  """
  alias Velzon.Accounts.User

  def call(user, params) when is_map(params) do
    user = User.creation_changeset(user, params)
    Velzon.Repo.insert(user)
  end
end
