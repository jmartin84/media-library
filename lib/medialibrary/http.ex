defmodule Medialibrary.Http do
  @moduledoc "Collection of methods to handle http operations"
  require HTTPotion
  require Poison

  def get(url, headers) do
    HTTPotion.get(
      url,
      stream_to: self(),
      headers: headers
    )

    response = receive_response()

    case response do
      {:ok, %{:data => data}} -> Poison.decode(data)
      {:error, _} -> response
    end
  end

  def post(url, body) do
    options = [
      body: Poison.encode!(body),
      stream_to: self(),
      headers: ["Content-Type": "application/json"]
    ]

    HTTPotion.post(url, options)

    receive_response()
  end

  defp receive_response(results \\ %{})
  defp receive_response(results = {:error, _}), do: results
  defp receive_response(results = {:ok, _}), do: results

  defp receive_response(results) do
    receive do
      %HTTPotion.AsyncChunk{chunk: chunk} ->
        results
        |> Map.get_and_update(:data, fn
          data when is_nil(data) -> {data, chunk}
          data -> {data, data <> chunk}
        end)
        |> elem(1)
        |> receive_response()

      %HTTPotion.AsyncHeaders{status_code: code} when code >= 400 ->
        {:error, %{:msg => "HTTP Request: failed with #{code}", :status => code}}

      %HTTPotion.AsyncEnd{} ->
        receive_response({:ok, results})

      %HTTPotion.ErrorResponse{message: message} ->
        receive_response({:error, %{:msg => "HTTP Request Error: #{message}", :status => 500}})
        after
          15_000 ->
            {:error, %{:msg => "HTTP Request: Operation Timed out", :status => 504}}
            |> receive_response()
    end
  end
end
