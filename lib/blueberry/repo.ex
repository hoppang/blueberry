defmodule Blueberry.Repo do
  use Ecto.Repo,
    otp_app: :blueberry,
    adapter: Ecto.Adapters.Postgres
end
