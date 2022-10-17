defmodule Motm.Repo do
  use Ecto.Repo,
    otp_app: :motm,
    adapter: Ecto.Adapters.Postgres
end
