defmodule Service.MixProject do
  use Mix.Project

  def project do
    [
      app: :service,
      version: "1.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Service.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:bandit, "~> 1.0"},
      {:plug, "~> 1.18"}
    ]
  end

  defp aliases do
    [
      test: ["test --no-start"]
    ]
  end
end
