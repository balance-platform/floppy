defmodule Floppy.MixProject do
  use Mix.Project

  @source_url "https://github.com/balance-platform/floppy"
  @version "0.1.0"

  def project do
    [
      app: :floppy,
      version: @version,
      elixir: "~> 1.9",
      aliases: aliases(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      description: description(),
      package: package(),
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      dialyzer: [
        plt_add_deps: :transitive
      ],
      homepage_url: @source_url,
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0.0-rc.7", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.21", only: [:dev], runtime: false},
      {:excoveralls, "~> 0.12.2", only: [:test], runtime: false}
    ]
  end

  defp description do
    """
    Elixir client for ClickHouse, a fast open-source Online Analytical
    Processing (OLAP) database management system.
    """
  end

  defp package do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "floppy",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README*),
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp aliases do
    [
      test: ["format --check-formatted", "test"]
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end
