defmodule BlueberryWeb.RequestLogger do
  require Logger

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    # Logger.warning("RequestLogger! #{inspect(conn, pretty: true)}")
    Logger.info("Remote IP: #{inspect(tuple_to_ipstr(conn.remote_ip))}")

    conn
  end

  @spec tuple_to_ipstr({integer, integer, integer, integer}) :: String.t()
  defp tuple_to_ipstr(ip) do
    {a, b, c, d} = ip

    "#{a}.#{b}.#{c}.#{d}"
  end
end
