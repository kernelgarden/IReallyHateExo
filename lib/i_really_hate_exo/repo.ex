defmodule IReallyHateExo.Repo do
  use Ecto.Repo,
    otp_app: :i_really_hate_exo,
    adapter: Ecto.Adapters.Postgres
end
