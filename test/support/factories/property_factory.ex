defmodule RoomHere.PropertyFactory do
  defmacro __using__(_opts) do
    quote do
      def property_factory do
        %RoomHere.Listings.Property{
          id: sequence(:id, & &1),
          description:
            "This is an accurate retelling of how bad Honorius was and his chickens.  Is this really the path you want to go down for the glory of Rome in late or much later antiquity or the dark ages of the Western Roman Empire.  Such a period filled with strife and anger and darkness as Alaric and Attila combined together as the literal anti-avengers team to crush the Romans and their Sagittarri and their rusty if any Lorica Segmentata.",
          first_available_date: NaiveDateTime.add(NaiveDateTime.local_now(), 45, :day),
          minimum_term: 2,
          maximum_term: 12,
          slug: :crypto.strong_rand_bytes(16) |> Base.url_encode64() |> binary_part(0, 16),
          title: "Oh don't be so hasty in this property now"
        }
      end

      def property_with_primary_user_factory do
        RoomHere.Factory.build(:property,
          property_users: [RoomHere.Factory.build(:property_user_primary)]
        )
      end
    end
  end
end
