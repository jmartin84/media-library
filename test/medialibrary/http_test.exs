defmodule Medialibrary.HttpTest do
  @moduledoc false
  use ExUnit.Case
  alias Plug.Conn, as: Conn
  alias Medialibrary.Http, as: Http

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  test "will return {:ok, results} when get request succeeds", %{bypass: bypass} do
    Bypass.expect(bypass, "GET", "/test", fn conn ->
      header =
        conn
        |> Conn.get_req_header("accept")
        |> hd

      assert header == "application/json"
      Conn.resp(conn, 200, ~s<{"a": 1}>)
    end)

    response = Http.get("http://localhost:#{bypass.port}/test", Accept: "application/json")

    case response do
      {:error, %{:msg => message}} -> raise "Response did not return :ok got #{message}"
      {:ok, result} -> assert result["a"] == 1
    end
  end

  test "will return {:error, message} when get request returns a status code of 400 or higher", %{
    bypass: bypass
  } do
    Bypass.expect(bypass, "GET", "/test", fn conn ->
      Conn.resp(conn, 400, "")
    end)

    response = Http.get("http://localhost:#{bypass.port}/test", Accept: "application/json")

    case response do
      {:error, %{:msg => msg, :status => status}} ->
        assert status == 400
        assert msg == "HTTP Request: failed with 400"

      {:ok, _} ->
        raise "Http request was expected to fail"
    end
  end

  test "will return {:ok, results} when post request succeeds", %{bypass: bypass} do
    Bypass.expect(bypass, "POST", "/test", fn conn ->
      header =
        conn
        |> Conn.get_req_header("content-type")
        |> hd

      case Conn.read_body(conn) do
        {:ok, body, _} ->
          data = Poison.decode!(body)
          assert data["a"] == 1

        {:error, _} ->
          raise "unable to read test request body"
      end

      assert header == "application/json"
      Conn.resp(conn, 200, "success")
    end)

    response = Http.post("http://localhost:#{bypass.port}/test", %{:a => 1})

    case response do
      {:error, %{:msg => message}} -> raise "Response did not return :ok got #{message}"
      {:ok, %{:data => result}} -> assert result == "success"
    end
  end

  test "will return {:error, message} when post request fails", %{bypass: bypass} do
    Bypass.expect(bypass, "POST", "/test", fn conn ->
      header =
        conn
        |> Conn.get_req_header("content-type")
        |> hd

      case Conn.read_body(conn) do
        {:ok, body, _} ->
          data = Poison.decode!(body)
          assert data["a"] == 1

        {:error, _} ->
          raise "unable to read test request body"
      end

      assert header == "application/json"
      Conn.resp(conn, 500, "success")
    end)

    response = Http.post("http://localhost:#{bypass.port}/test", %{:a => 1})

    case response do
      {:error, %{:msg => msg, :status => status}} ->
        assert status == 500
        assert msg == "HTTP Request: failed with 500"

      {:ok, _} ->
        raise "Http request was expected to fail"
    end
  end
end
