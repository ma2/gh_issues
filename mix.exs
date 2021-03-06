defmodule GhIssues.MixProject do
  use Mix.Project

  def project do
    [
      app: :gh_issues,
      escript: escript_config(),
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      name: "GhIssues",
      source_url: "https://github.com/ma2/gh_issues",
      deps: deps()
    ]
  end

  # ここで起動時に実行されるアプリケーションを指定できる
  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [ :logger, :httpoison ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      httpoison: "~>1.0.0",
      poison: "~>3.1.0",
      ex_doc: "~>0.18.0",
      earmark: "~>1.2.0",
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp escript_config do
    [ main_module: GhIssues.Cli ]
  end
end
