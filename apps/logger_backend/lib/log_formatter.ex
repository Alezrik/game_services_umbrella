defmodule LogFormatter do
  @moduledoc """
    Log Formatter
  """

  @protected [:password]
  @filter [:function, :pid, :line, :file, :application, :request_id]

  def format(level, message, timestamp, metadata) do
    case Keyword.get(metadata, :request_id, "") do
      "" ->
        "#{fmt_timestamp(timestamp)} -  [#{level}] : #{message} :: #{fmt_metadata(metadata)}\n"

      id ->
        "#{fmt_timestamp(timestamp)} - request_id: #{Keyword.get(metadata, :request_id, "")} [#{
          level
        }] : #{message} :: #{fmt_metadata(metadata)}\n"
    end
  end

  defp fmt_timestamp({date, {hh, mm, ss, ms}}) do
    with {:ok, timestamp} <- NaiveDateTime.from_erl({date, {hh, mm, ss}}, {ms * 1000, 3}),
         result <- NaiveDateTime.to_iso8601(timestamp) do
      "#{result}Z"
    end
  end

  defp fmt_metadata(md) do
    md
    |> Keyword.keys()
    |> Enum.filter(fn x -> !Enum.member?(@filter, x) end)
    |> Enum.map(&output_metadata(md, &1))
    |> Enum.join(" ")
  end

  def output_metadata(metadata, key) do
#    m = Keyword.get(metadata, key)
    if is_map(Keyword.get(metadata, key)) do
      process_map(Keyword.get(metadata, key))
    else
      process_value(metadata, key)
    end

  end
  def process_map(map) do
    "(LOG REDACTED MAP)"
  end
  def process_value(metadata, key) do
    if Enum.member?(@protected, key) do
      "#{key}=(REDACTED)"
    else
      "#{key}=#{inspect(metadata[key])}"
    end
  end
end
