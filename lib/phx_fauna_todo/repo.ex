defmodule PhxFaunaTodo.Repo do
  use Ecto.Repo,
    otp_app: :phx_fauna_todo,
    adapter: Ecto.Adapters.SQLite3
end
