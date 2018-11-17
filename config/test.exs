use Mix.Config

# Print only warnings and errors during test
config :logger, :console,
  level: :debug,
  format: {LogFormatter, :format},
  metadata: :all
