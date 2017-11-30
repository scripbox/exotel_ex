defmodule ExotelEx.HttpMessenger do
  @behaviour ExotelEx.Messenger
  @endpoint "https://api.exotel.com/v1/Accounts/"
  @ets_bucket_name "exotel-rate-limited-api"

  # Public API

  @doc """
  The send_sms/4 function sends an sms to a
  given phone number from a given phone number.
  ## Example:
      ```
      iex(1)> ExotelEx.HttpMessenger.send_sms("15005550006", "15005550001", "test message")
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
    check_rate_limit!() # raises ApiLimitExceeded if rate limit exceeded

    case HTTPoison.post(send_sms_url(), sms(from, to, body, media), auth_header()) do
      {:ok, response} -> process_response(response)
      {:error, error} -> raise ExotelEx.Errors.ApiError, error.reason
    end
  end

  @doc """
  The sms_details/1 function gets an sms details.
  ## Example:
      ```
      iex(1)> ExotelEx.HttpMessenger.sms_details("sms_sid")
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
    check_rate_limit!() # raises ApiLimitExceeded if rate limit exceeded

    case HTTPoison.get(sms_details_url(sms_sid), auth_header()) do
      {:ok, response} -> process_response(response)
      {:error, error} -> raise ExotelEx.Errors.ApiError, error.reason
    end
  end

  @doc """
  The time_to_next_bucket/0 function gets the time in seconds to next bucket limit.
  ## Example:
      ```
      iex(1)> ExotelEx.HttpMessenger.time_to_next_bucket
      {:ok, 5} # 5 secconds to next bucket reset
      ```
  """
  @spec time_to_next_bucket() :: tuple()
  def time_to_next_bucket do
    {_, _, ms_to_next_bucket, _, _} = ExRated.inspect_bucket(@ets_bucket_name,
                                                             time_scale_in_ms(),
                                                             api_limit())
    sec_to_next_bucket = round(ms_to_next_bucket / 1000.0)
    {:ok, sec_to_next_bucket}
  end

  # Private API

  defp check_rate_limit! do
    case ExRated.check_rate(@ets_bucket_name, time_scale_in_ms(), api_limit()) do
      {:ok, current_count} -> {:ok, current_count}
      {:error, current_count} ->
        raise ExotelEx.Errors.ApiLimitExceeded, "API rate limit exceeded - #{current_count}"
     end
  end

  defp sid do
    Application.get_env(:exotel_ex, :sid)
  end

  defp token do
    Application.get_env(:exotel_ex, :token)
  end

  defp time_scale_in_ms do
    {time_scale, _} = Integer.parse(Application.get_env(:exotel_ex, :rate_limit_scale))
    time_scale
  end

  defp api_limit do
    {api_limit_rate, _} = Integer.parse(Application.get_env(:exotel_ex, :rate_limit_count))
    api_limit_rate
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
