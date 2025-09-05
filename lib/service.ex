defmodule Service do
  @moduledoc false

  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  @participants [
    {"Zoey", "zoedsoupe"},
    {"Pablo", "PaBLOHenCh"}
  ]

  get "/" do
    send_json(conn, :im_a_teapot, %{
      message: """
      Serviço rodando normalmente, vai um cafézin?!?
      """
    })
  end

  get "/health" do
    send_json(conn, :ok, %{status: "saudável", timestamp_unix: System.os_time()})
  end

  get "/info" do
    if vsn = Application.spec(:service, :vsn) do
      {:ok, host} = :inet.gethostname()

      send_json(conn, :ok, %{
        version: List.to_string(vsn),
        hostname: List.to_string(host),
        participants: Map.new(@participants)
      })
    else
      send_json(conn, :internal_error, %{message: "não é possível ver a versão atual do serviço"})
    end
  end

  match _ do
    send_json(conn, :not_found, %{message: "Página não encontrada!"})
  end

  defp send_json(%Plug.Conn{} = conn, status, %{} = body) do
    conn = put_resp_content_type(conn, "application/json")
    body = JSON.encode_to_iodata!(body)
    send_resp(conn, status, body)
  end
end
