defmodule ExotelEx.Mixfile do
  use Mix.Project

  def project do
    [
      app: :exotel_ex,
      version: "0.1.0",
      elixir: "~> 1.5",
      description: "An Elixir client for communicating with Exotel APIs",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      package: package(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :httpoison],
      mod: {ExotelEx, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 0.13.0"},
      {:poison, "~> 3.1"}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      maintainers: ["Scripbox"],
      links: %{"GitHub" => "https://github.com/scripbox/exotel_ex"}
    ]
  end
end
