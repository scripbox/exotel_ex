defmodule ExotelEx.Errors.ApiError do
  defexception [:reason]

  def exception(reason),
    do: %__MODULE__{reason: reason}

  def message(%__MODULE__{reason: reason}),
    do: "ExotelEx::ApiError - #{reason}"
end

defmodule ExotelEx.Errors.ApiLimitExceeded do
  defexception [:reason]

  def exception(reason),
    do: %__MODULE__{reason: reason}

  def message(%__MODULE__{reason: reason}),
    do: "ExotelEx::ApiLimitExceeded - #{reason}"
end
