defmodule RoomHere.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %RoomHere.Accounts.User{
          id: sequence(:user_id, & &1),
          email: sequence(:email, &"test-#{&1}@roomhere.com")
        }
      end
    end
  end
end
