# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :mehungry_server,
  ecto_repos: [MehungryServer.Repo]

# Configures the endpoint
config :mehungry_server, MehungryServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bScxJ7J8MkJpYvem6Ari5UA2OiPFJHccti9fEabWzhmzKIXgXaU5p2g9OmYBbA/A",
  render_errors: [view: MehungryServerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MehungryServer.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "pi4wNunEjLhwwS36ovMNMbTK1unUgbCi"
  ]

# Guardian config
config :mehungry_server, MehungryServerWeb.Guardian,
       issuer: "mehungry_server",
       secret_key: "xqo0BfDpsWTY/ZDz/+nmsbdLFLfZEmU3qXhJzdtc3qS7GZyji91GLgE15nYoVbxt"

config :mehungry_server, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: MehungryServerWeb.Router,     # phoenix routes will be converted to swagger paths
      endpoint: MehungryServerWeb.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
  }


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
