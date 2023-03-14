# RoomHere

An Elixir Phoenix implementation of SpareRoom! Currently in progress as of March 2023.

To start your Phoenix server:

- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Run `make start` to start the docker container containing the Postgres DB
- Make sure you have a `.envrc` file containing the needed keys for `dev.exs` (direnv is helpful here for your local environment)
- Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

To spin down your Phoenix server:

- Run `make stop` to stop the docker container
- Double CTRL/CONTROL+C out of your IEX session

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).
