defmodule RoomHere.TestHelperFunctions do
  def generate_form_friendly_first_available_date do
    NaiveDateTime.local_now()
    |> NaiveDateTime.add(45, :day)
    |> NaiveDateTime.to_iso8601()
  end
end
