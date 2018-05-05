defmodule Medialibrary.Http do
	@moduledoc "Collection of methods to handle http operations"
	require HTTPotion
	require Poison

	def get(url, headers) do
		HTTPotion.get url, [
			headers: headers,
			stream_to: self()
		]

		receive_response()
	end

	def post(url, body) do
		options = [
			body: Poison.encode!(body),
			stream_to: self(),
			headers: ["Content-Type": "application/json"]
		]

		HTTPotion.post url, options

		receive_response()
	end

	defp receive_response(results)

	defp receive_response(%{status: code, headers: headers, data: data}) when code >= 400,
		do: {:error, [msg: data, status: code, headers: headers]}

	defp receive_response(results = {:error, _}), do: results
	defp receive_response(results) when map_size(results) == 3, do: {:ok, results}

	defp receive_response(results \\ %{}) do
		receive do
			%HTTPotion.AsyncChunk{chunk: chunk} ->
				results
					|> Map.put(:data, chunk)
					|> receive_response()

			%HTTPotion.AsyncHeaders{
				status_code: status,
				headers: %HTTPotion.Headers{hdrs: headers}
			} -> results
					|> Map.put(:status, status)
					|> Map.put(:headers, headers)
					|> receive_response()

			%HTTPotion.ErrorResponse{message: message} ->
				receive_response({:error, [msg: "HTTP Request Error: #{message}", status: 500]})
	   after
			5_000 -> {:error, [msg: "HTTP Request: Operation Timed out", status: 504]} |> receive_response()
	   end
	end

end
