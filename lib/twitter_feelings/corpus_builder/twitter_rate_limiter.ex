defmodule TwitterFeelings.CorpusBuilder.TwitterRateLimiter do

  require Logger

  # Handles Twitter API rate limit errors
  def handle_rate_limit(fun) do
    try do
      fun.()
    rescue
      error in ExTwitter.RateLimitExceededError ->
        time_to_sleep = max(0, error.reset_in)
        Logger.debug("rate limit reached, sleeping #{time_to_sleep}s")
        :timer.sleep(round(time_to_sleep * 1000))
        handle_rate_limit(fun)
    end
  end

end
