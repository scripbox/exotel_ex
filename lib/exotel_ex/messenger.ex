defmodule ExotelEx.Messenger do
  @endpoint "https://api.exotel.com/v1/Accounts/"

  # Public API

  @doc """
  The send_sms/4 function sends an sms to a
  given phone number from a given phone number.
  ## Example:
      ```
      iex(1)> ExotelEx.Messenger.send_sms("15005550006", "15005550001", "test message")
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
  def send_sms(from, to, body, media \\ "") do
    case HTTPoison.post(send_sms_url(), sms(from, to, body, media), auth_header()) do
      {:ok, response} -> process_response(response)
      {:error, error} -> raise ExotelEx.Errors.ApiError, error.reason
    end
  end

  @doc """
  The sms_details/1 function gets an sms details.
  ## Example:
      ```
      iex(1)> ExotelEx.Messenger.sms_details("sms_sid")
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
    case HTTPoison.get(sms_details_url(sms_sid), auth_header()) do
      {:ok, response} -> process_response(response)
      {:error, error} -> raise ExotelEx.Errors.ApiError, error.reason
    end
  end

  # Private API

  defp sid do
    Application.get_env(:exotel_ex, :sid)
  end

  defp token do
    Application.get_env(:exotel_ex, :token)
  end

  defp send_sms_url do
    "#{@endpoint}#{sid()}/Sms/send.json"
  end

  defp sms_details_url(sms_sid) do
    "#{@endpoint}#{sid()}/SMS/Messages/#{sms_sid}.json"
  end

  defp process_response(%HTTPoison.Response{body: body}) do
    Poison.decode!(body, keys: :atom)
  end

  defp sms(from, to, body, media) do
    {:form, [To: to, From: from, Body: body, MediaUrl: media]}
  end

  defp auth_header do
    encoded_token = Base.encode64("#{sid()}:#{token()}")

    [
      {"Authorization", "Basic " <> encoded_token}
    ]
  end
end
