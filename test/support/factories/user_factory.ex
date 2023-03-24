defmodule RoomHere.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %RoomHere.Accounts.User{
          id: sequence(:user_id, & &1),
          email: sequence(:email, &"test-#{&1}@roomhere.com"),
          # pw: mrworldworldwide
          hashed_password: "$2b$12$q/wCQQN/h/FflOpnLJ3SpOzjRgeYx/hoRqflOcBDKxSfHEtOfR0l2",
          confirmed_at: NaiveDateTime.local_now()
        }
      end
    end
  end
end
