defmodule ElixirIpfsApi.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_ipfs_api,
      version: "0.1.1",
      elixir: "~> 1.6",
      description: "An elixir client library for the IPFS API",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger, :httpoison]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1", override: true},
      {:inch_ex, "~> 0.5", only: :docs},
      {:ex_doc, "~> 0.18.3", only: :dev},
      {:earmark, "~> 1.2", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Zohaib Rauf"],
      license: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/zabirauf/elixir-ipfs-api",
        "Docs" => "http://hexdocs.pm/elixir_ipfs_api"
      }
    ]
  end
end
