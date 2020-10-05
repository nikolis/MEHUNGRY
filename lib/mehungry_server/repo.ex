defmodule MehungryServer.Repo do
  use Ecto.Repo,
    otp_app: :mehungry_server,
    adapter: Ecto.Adapters.Postgres
end
