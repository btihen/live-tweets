defmodule Tweets.Repo do
  use Ecto.Repo,
    otp_app: :tweets,
    adapter: Ecto.Adapters.Postgres
end
