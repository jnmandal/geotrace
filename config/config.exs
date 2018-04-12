# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :geocoder, :worker_pool_config, [
  size: 4,
  max_overflow: 2
]

config :geocoder, :worker, [
  provider: Geocoder.Providers.GoogleMaps
]
