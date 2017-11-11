# ExotelEx

An Elixir client for communicating with Exotel APIs

## Install

1. Add exotel_ex to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:exotel_ex, "~> 0.0.1"}]
  end
  ```

2. Ensure exotel_ex is started before your application:

  ```elixir
  def application do
    [applications: [:exotel_ex]]
  end
  ```


## Configure

Add the following to your `config.exs` file:

```elixir
config :exotel_ex,
  sid: "YOUR_EXOTEL_SID",
  token: "YOUR_EXOTEL_TOKEN"
```

## Usage

1. Send SMS
  * The `send_sms/4` function sends an sms to a given phone number from a given phone number.

```elixir
 # ExotelEx.Messenger.send_sms("from_number", "to_number", "body_text", "optional_media_url")
 iex(1)> ExotelEx.Messenger.send_sms("15005550006", "15005550001", "test text", "https://github.com")
```

2. Get SMS Details
  * The `sms_details/1` function gets an sms details.

```elixir
 # ExotelEx.Messenger.sms_details("sms_sid")
 iex(1)> ExotelEx.Messenger.sms_details("sms_sid")
```
