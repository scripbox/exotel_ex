defmodule ExotelEx.InMemoryMessenger do
  @behaviour ExotelEx.Messenger

  # Public API

  @doc """
  The send_sms/4 function sends an sms to a
  given phone number from a given phone number.
  ## Example:
      ```
      iex(1)> ExotelEx.Messenger.InMemoryAdapter.send_sms("15005550006", "15005550001", "test message")
      %{"SMSMessage" => %{
          "AccountSid" => "probe",
          "ApiVersion" => nil,
          "Body" => "test message",
          "DateCreated" => "2017-11-12 00:24:31",
          "DateSent" => nil,
          "DateUpdated" => "2017-11-12 00:24:31",
          "DetailedStatus" => "PENDING_TO_OPERATOR",
          "DetailedStatusCode" => 21010,
          "Direction" => "outbound-api",
          "From" => "01139595093/SCRPBX",
          "Price" => nil,
          "Sid" => "6dbfdc50133d0e51ec8d793356559868",
          "Status" => "queued",
          "To" => "08884733565",
          "Uri" => "/v1/Accounts/probe/SMS/Messages/6dbfdc50133d0e51ec8d793356559868.json"}}
      ```
  """
  @spec send_sms(String.t(), String.t(), String.t(), String.t()) :: map()
  def send_sms(from, to, body, _ \\ "") do
    %{
      "SMSMessage" => %{
        "AccountSid" => "account_sid",
        "ApiVersion" => nil,
        "Body" => body,
        "DateCreated" => "2017-11-12 00:24:31",
        "DateSent" => nil,
        "DateUpdated" => "2017-11-12 00:24:31",
        "DetailedStatus" => "PENDING_TO_OPERATOR",
        "DetailedStatusCode" => 21010,
        "Direction" => "outbound-api",
        "From" => from,
        "Price" => nil,
        "Sid" => "3412jhkj4123h4kj123h4lk12j3h4lk12j34",
        "Status" => "queued",
        "To" => to,
        "Uri" => "/v1/Accounts/probe/SMS/Messages/3412jhkj4123h4kj123h4lk12j3h4lk12j34.json"
      }
    }
  end

  @doc """
  The sms_details/1 function gets an sms details.
  ## Example:
      ```
      iex(1)> ExotelEx.Messenger.InMemoryAdapter.sms_details("sms_sid")
      %{"SMSMessage" => %{
          "AccountSid" => "probe",
          "ApiVersion" => nil,
          "Body" => "test message",
          "DateCreated" => "2017-11-12 00:24:31",
          "DateSent" => "2017-11-12 00:24:35",
          "DateUpdated" => "2017-11-12 00:24:36",
          "DetailedStatus" => "DELIVERED_TO_HANDSET",
          "DetailedStatusCode" => 20005,
          "Direction" => "outbound-api",
          "From" => "01139595093/SCRPBX",
          "Price" => "0.180000",
          "Sid" => "6dbfdc50133d0e51ec8d793356559868",
          "Status" => "sent",
          "To" => "08884733565",
          "Uri" => "/v1/Accounts/probe/SMS/Messages/6dbfdc50133d0e51ec8d793356559868.json"}}
      ```
  """
  @spec sms_details(String.t()) :: map()
  def sms_details(sms_sid) do
    %{
      "SMSMessage" => %{
        "AccountSid" => "account_sid",
        "ApiVersion" => nil,
        "Body" => "test message",
        "DateCreated" => "2017-11-12 00:24:31",
        "DateSent" => nil,
        "DateUpdated" => "2017-11-12 00:24:31",
        "DetailedStatus" => "PENDING_TO_OPERATOR",
        "DetailedStatusCode" => 21010,
        "Direction" => "outbound-api",
        "From" => "01139595093/SCRPBX",
        "Price" => nil,
        "Sid" => sms_sid,
        "Status" => "sent",
        "To" => "08884733565",
        "Uri" => "/v1/Accounts/probe/SMS/Messages/#{sms_sid}.json"
      }
    }
  end
end
