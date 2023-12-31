defmodule BlueberryWeb.RequestLogger do
  @moduledoc """
  모든 페이지 접속시 기록을 남기기 위한 모듈
  """

  require Logger

  @behaviour Plug

  @spec init(Keyword.t()) :: Keyword.t()
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), Keyword.t()) :: Plug.Conn.t()
  def call(conn, _opts) do
    remote_ip = remote_ip(conn)
    Logger.info("Remote IP: #{inspect(remote_ip)}")
    Schema.ConnectionCount.upsert(remote_ip, "-")

    conn
  end

  @doc """
  https://websymphony.net/blog/how-to-get-remote-ip-from-x-forwarded-for-in-phoenix/ 에서 가져옴

  https://adam-p.ca/blog/2022/03/x-forwarded-for/ 이 문서에 따르면 x-forwarded-for 를 클라이언트 IP 판별에 쓰는 건 안 될 일이지만
  대안이 없잖아...
  (엄격한 클라이언트 IP 처리가 필요하면 https 레벨이 아닌 더 윗단계(방화벽이라던가) 에서 처리해야 할 듯)
  """
  @spec remote_ip(Plug.Conn.t()) :: binary()
  def remote_ip(conn) do
    forwarded_for =
      conn
      |> Plug.Conn.get_req_header("x-forwarded-for")
      |> List.first()

    if forwarded_for do
      forwarded_for
      |> String.split(",")
      |> Enum.map(&String.trim/1)
      |> List.first()
    else
      conn.remote_ip
      |> :inet_parse.ntoa()
      |> to_string()
    end
  end
end
