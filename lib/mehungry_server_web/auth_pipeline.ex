defmodule MehungryServerWeb.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :mehungry_server,
  module: MehungryServerWeb.Guardian,
  error_handler: MehungryServerWeb.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource


end
