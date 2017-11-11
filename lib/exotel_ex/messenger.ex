defmodule ExotelEx.Messenger do
  @endpoint "https://api.exotel.com/v1/Accounts/"

  # Public API

  @doc """
  The send_sms/4 function sends an sms to a
  given phone number from a given phone number.
  ## Example:
      ```
      iex(1)> ExotelEx.Messenger.send_sms("15005550006", "15005550001", "test text")
      ```
  """
  @spec send_sms(String.t(), String.t(), String.t(), String.t()) :: map()
  def send_sms(from, to, body, media \\ "") do
    send_sms_url()
    |> HTTPoison.post!(sms(from, to, body, media), auth_header())
    |> process_response()
  end

  @doc """
  The sms_details/1 function gets an sms details.
  ## Example:
      ```
      iex(1)> ExotelEx.Messenger.sms_details("sms_sid")
      ```
  """
  @spec sms_details(String.t()) :: map()
  def sms_details(sms_sid) do
    sms_details_url(sms_sid)
    |> HTTPoison.get!(auth_header())
    |> process_response()
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
