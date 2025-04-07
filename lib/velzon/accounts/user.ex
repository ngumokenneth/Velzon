defmodule Velzon.Accounts.User do
  @moduledoc """
  This schema represents a single user of the system
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Velzon.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field(:email, :string)
    # field(:password_hash, :string)
    field(:username, :string)
    field(:password, :string, redact: true)

    timestamps(type: :utc_datetime)
  end

  def changeset(%User{} = user, attrs) do
    required_fields = [:email, :username, :password]

    user
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
    |> validate_format(:email, ~r/@/, message: "Please enter a valid email address")
    |> unsafe_validate_unique(:email, Velzon.Repo, message: "Email already in use")
    |> unsafe_validate_unique(:username, Velzon.Repo, message: "Username already in use")
    # |> put_password_hash()
    |> validate_length(:password, min: 4, max: 12)
  end

  def creation_changeset(%User{} = user, attrs \\ %{}) do
    required_fields = [:email, :username, :password]

    user
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
    |> validate_format(:email, ~r/@/)
    |> unsafe_validate_unique(:email, Velzon.Repo, message: "Email already in use")
    |> unsafe_validate_unique(:username, Velzon.Repo, message: "Username already in use")
    # |> put_password_hash()
    |> validate_length(:password, min: 4, max: 12)
  end

  # defp put_password_hash(%{valid?: valid} = changeset) do
  #   hash = valid && get_change(changeset, :password)
  #   if hash, do: do_put_password_hash(changeset), else: changeset
  # end

  #   defp do_put_password_hash(%{changes: %{password: password}} = changeset) do
  #     hash = Argon2.hash_pswd_salt(password)
  #     changeset |> put_change(:password_hash, hash) |> delete_change(:password)
  #   end
end
