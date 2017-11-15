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

* **For Development/Test environments**

Add the following to your `config/dev.exs`/`config/test.exs` file:

```elixir
config :telex, :exotel_ex_api, ExotelEx.InMemoryMessenger
```

* **For Staging/Production environments**

Add the following to your `config/staging.exs`/`config/production.exs` file:

```elixir
config :telex, :exotel_ex_api, ExotelEx.HttpMessenger
```

## Usage

1. Set the messenger to use at the top level
```elixir
  @exotel_api_client Application.get_env(:telex, :exotel_ex_api)
```


2. Send SMS
  * The `send_sms/4` function sends an sms to a given phone number from a given phone number.

  ```elixir
 # @exotel_api_client.send_sms("from_number", "to_number", "body_text", "optional_media_url")
 iex(1)> @exotel_api_client.send_sms("15005550006", "15005550001", "test text", "https://github.com")
```

3. Get SMS Details
  * The `sms_details/1` function gets an sms details.

```elixir
 # @exotel_api_client.sms_details("sms_sid")
 iex(1)> @exotel_api_client.sms_details("sms_sid")
```
