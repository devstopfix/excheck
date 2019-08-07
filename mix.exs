defmodule ExCheck.Mixfile do
  use Mix.Project

  def project do
    [
      app: :excheck,
      name: "ExCheck",
      source_url: "https://github.com/devstopfix/excheck",
      homepage_url: "https://github.com/parroty/ExCheck.git",
      version: "0.7.4",
      elixir: "~> 1.5",
      deps: deps(),
      description: description(),
      package: package()
      # test_coverage: [tool: ExCoveralls],
      # preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test]
    ]
  end

  def application do
    [
      applications: [:triq],
      mod: {ExCheck, []}
    ]
  end

  def deps do
    [
      # {:excoveralls, "~> 0.5", only: :test},
      {:triq, "~> 1.3", only: [:dev, :test]},
      {:ex_doc, "~> 0.12", only: :dev},
      {:inch_ex, only: :docs}
    ]
  end

  defp description do
    """
    Property-based testing library for Elixir (QuickCheck style).
    """
  end

  defp package do
    [
      maintainers: ["parroty"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/parroty/excheck",
        "Fork" => "https://github.com/devstopfix/excheck",
        "CI" => "https://travis-ci.org/devstopfix/excheck"
      }
    ]
  end
end
