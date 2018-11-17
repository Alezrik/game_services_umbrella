use Mix.Config

# Print only warnings and errors during test
config :logger, :console,
  level: :error,
  format: {LogFormatter, :format},
  metadata: :all
