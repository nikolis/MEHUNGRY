defmodule MehungryServerWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :mehungry_server
  plug CORSPlug
  
    @session_options [
      store: :cookie,
      key: "_mehungry_server_key",
      signing_salt: "Hrv0Nd/S"
    ]

  socket "/socket", MehungryServerWeb.UserSocket,
    websocket: true,
    longpoll: false
  
  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]
  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :mehungry_server,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
"""
  plug Plug.Session,
    store: :cookie,
    key: "_mehungry_server_key",
    signing_salt: "9qzwE5oP"

    plug MehungryServerWeb.Router
"""
  import Phoenix.LiveDashboard.Router
  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug MehungryServerWeb.Router

end
