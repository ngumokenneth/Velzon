defmodule Velzon.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Velzon.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"
  def valid_full_name, do: "Alpha Kent"
  def valid_location, do: "Nyeri"
  def valid_phone_number, do: "0731234567"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password(),
      full_name: valid_full_name(),
      location: valid_location(),
      phone_number: valid_phone_number()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Velzon.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
