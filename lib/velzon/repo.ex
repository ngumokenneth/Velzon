defmodule Velzon.Repo do
  use Ecto.Repo,
    otp_app: :velzon,
    adapter: Ecto.Adapters.Postgres
end
