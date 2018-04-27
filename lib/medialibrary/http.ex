defmodule Medialibrary.Http do
	require HTTPotion
	require Poison

	def post(url, body, handle_response) do
		url = Application.get_env(:medialibrary, :elastic_search) <> url
		HTTPotion.post url, [
			body: Poison.encode!(body),
			stream_to: self(),
			headers: ["Content-Type": "application/json"]
		]

		on_success = fn data ->
			data
			|> Poison.decode()
			|> handle_response.()
		end

	   receive do
			%HTTPotion.AsyncChunk{chunk: chunk} -> on_success.(chunk)
			%HTTPotion.ErrorResponse{message: message} -> {:error, %{:msg => "HTPP Request Error: #{message}"}} # catch all
	   after
			5_000 -> {:error, %{message: "HTTP Request: Operation Timed out" }}
	   end
	end

end
