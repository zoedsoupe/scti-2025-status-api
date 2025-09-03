defmodule ServiceTest do
  use ExUnit.Case, async: true

  import Plug.Test

  @moduletag capture_log: true

  @opts Service.init([])

  test "GET / returns teapot status with coffee message" do
    conn = conn(:get, "/")
    conn = Service.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 418
    assert conn.resp_body =~ "Serviço rodando normalmente"
    assert conn.resp_body =~ "cafézin"
  end

  test "GET /health returns ok status with timestamp" do
    conn = conn(:get, "/health")
    conn = Service.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200

    body = JSON.decode!(conn.resp_body)
    assert body["status"] == "saudável"
    assert is_integer(body["timestamp_unix"])
  end

  test "GET /info returns version and hostname when available" do
    conn = conn(:get, "/info")
    conn = Service.call(conn, @opts)

    assert conn.state == :sent

    body = JSON.decode!(conn.resp_body)

    case conn.status do
      200 ->
        assert is_binary(body["version"])
        assert is_binary(body["hostname"])

      500 ->
        assert body["message"] == "não é possível ver a versão atual do serviço"
    end
  end

  test "returns 404 for unknown routes" do
    conn = conn(:get, "/unknown")
    conn = Service.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 404

    body = JSON.decode!(conn.resp_body)
    assert body["message"] == "Página não encontrada!"
  end

  test "returns correct content type for all responses" do
    routes = ["/", "/health", "/info", "/unknown"]

    for route <- routes do
      conn = conn(:get, route)
      conn = Service.call(conn, @opts)

      assert Plug.Conn.get_resp_header(conn, "content-type") == [
               "application/json; charset=utf-8"
             ]
    end
  end
end
