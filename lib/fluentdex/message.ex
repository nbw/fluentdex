defmodule Fluentdex.Message do
  defstruct [:tag, :records, :opts]

  alias Fluentdex.Msgpack

  def decode(data) do
    case Msgpack.unpack(data) do
      {:ok, [tag, record, opts]} ->
        {:ok, [create(tag, record, opts)]}
      {:ok, records} when is_list(records) ->
          messages = Enum.map(records, fn [tag, record, opts] ->
            {:ok, record} = Msgpack.unpack(record)
            create(tag, record, opts)
          end)
          {:ok, messages}
      {:error, _} = error ->
        error
    end
  end

  def create(tag, record, opts) do
    %__MODULE__{
      tag: tag,
      records: record,
      opts: opts
    }
  end
end
