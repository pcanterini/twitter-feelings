defmodule TwitterFeelings.Mixfile do
  use Mix.Project

  def project do
    [app: :twitter_feelings,
     version: "0.0.1",
     elixir: "~> 1.0",
     escript: escript_config,
     deps: deps]
  end

  def application do
    [
      applications: [:kernel, :stdlib, :logger, :inets, :ssl, :redis_pool, :httpoison],
      mod: {TwitterFeelings, []}
    ]
  end

  defp deps do
    [
      { :oauth, github: "tim/erlang-oauth" },
      { :extwitter, "~> 0.2" },
      { :httpoison, "~> 0.6" },
      { :timex, "~> 0.13.3" },
      { :redis_pool, git: "https://github.com/le0pard/redis_pool" },
      { :mock, "0.1.0", only: :test }
    ]
  end

  defp escript_config do
    [ main_module: TwitterFeelings ]
  end

end
