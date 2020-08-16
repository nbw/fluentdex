defmodule Fluentdex.Msgpack do
  def unpack(msgpack_data) do
    unpack_slice(msgpack_data)
  end

  defp unpack_slice(data, result \\ [])
  defp unpack_slice("", result) do
    {:ok, result}
  end
  defp unpack_slice(data, result) do
    case Msgpax.unpack_slice(data) do
      {:ok, decoded, remaining} ->
        unpack_slice(remaining, result ++ [decoded])
      {:error, _} = error ->
        error
    end
  end
end
