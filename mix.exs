defmodule ExCheck.Mixfile do
  use Mix.Project

  def project do
    [
      app: :excheck,
      name: "ExCheck",
      source_url: "https://github.com/devstopfix/excheck",
      homepage_url: "https://github.com/parroty/ExCheck.git",
      version: "0.7.0",
      elixir: "~> 1.5",
      deps: deps(),
      description: description(),
      package: package()
      # test_coverage: [tool: ExCoveralls],
      # preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test]
    ]
  end

  # Configuration for the OTP application
  def application do
    [mod: {ExCheck, []}]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  def deps do
    [
      # {:excoveralls, "~> 0.5", only: :test},
      {:triq, "~> 1.2", only: [:dev, :test]},
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
        "Fork" => "https://github.com/devstopfix/excheck"
      }
    ]
  end
end
