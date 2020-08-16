defmodule Fluentdex.Server do
  @moduledoc """
  https://ninenines.eu/docs/en/ranch/2.0/guide/protocols/
  """
  require Logger
  alias Fluentdex.Message

  @behaviour :ranch_protocol

  def child_spec(opts \\ []) do
    transport_opts = [port: 24230]
    :ranch.child_spec(__MODULE__, :ranch_tcp, transport_opts, __MODULE__, opts)
  end

  @impl :ranch_protocol
  def start_link(ref, _, transport, opts) do
    pid = :proc_lib.spawn_link(__MODULE__, :init, [ref, transport, opts])
    {:ok, pid}
  end

  def init(ref, transport, _opts) do
    {:ok, socket} = :ranch.handshake(ref)

    loop(socket, transport)
  end

  @doc """
  Loops and checks for incoming data.

  If a Msgpax error occurs it means there's still more data inbound, so
  save what you've received already (buffer) and loop again
  """
  def loop(socket, transport, buffer \\ <<>>) do
    case transport.recv(socket, 0, 5000) do
      {:ok, data} ->
        Logger.warn("incoming...")
        case Message.decode(buffer <> data) do
          {:ok, message} ->
            IO.inspect(message)
          {:error, %Msgpax.UnpackError{}} = error ->
            Logger.warn("#{inspect(__MODULE__)} error: #{inspect(error)}")
            loop(socket, transport, data)
        end
        loop(socket, transport, <<>>)
      {:error, _} ->
        transport.close(socket)
    end
  end
end
