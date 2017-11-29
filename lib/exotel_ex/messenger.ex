defmodule ExotelEx.Messenger do
  @moduledoc ~S"""
  Behaviour for creating ExotelEx.Messenger messengers
  For more in-depth examples check out the
  [messengers in ExotelEx](https://github.com/scripbox/exotel_ex/tree/master/lib/exotel_ex/messengers).
  """

  @callback send_sms(from :: String.t, to :: String.t, body :: String.t) :: map
  @callback sms_details(sms_sid :: String.t) :: map
  @callback time_to_next_bucket() :: tuple
end
