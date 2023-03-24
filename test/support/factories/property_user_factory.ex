defmodule RoomHere.PropertyUserFactory do
  defmacro __using__(_opts) do
    quote do
      def property_user_factory(attrs) do
        user = attrs[:user] || RoomHere.Factory.build(:user)

        puser = %RoomHere.PropertyUser{
          id: sequence(:property_user_id, & &1),
          is_primary_user: false,
          user: user
        }

        merge_attributes(puser, attrs)
      end

      def property_user_primary_factory do
        RoomHere.Factory.build(:property_user, is_primary_user: true)
      end
    end
  end
end
