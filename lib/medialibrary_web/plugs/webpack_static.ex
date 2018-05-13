defmodule MedialibraryWeb.Webpack_Static do
	alias HTTPotion, as: Http
	alias Plug.Conn, as: Conn
	require Poison

	def init([port, webpack_assets, env, manifest_path]) do
		[port, webpack_assets, env, manifest_path]
	end

	def call(conn, [
		{:port, port},
		{:webpack_assets, assets},
		{:env, env},
		{:manifest_path, manifest_path}
	]) do
		if env == :dev do
			manifest_task = Task.async(fn () -> get_manifest(manifest_path, port) end)
			serve_asset conn, port, assets, Task.await(manifest_task)
		else
			conn
		end
	end

	defp get_manifest(path, port) do
		url = "http://localhost:#{port}"
		|> URI.merge(path)
		|> URI.to_string()

		case Http.get(url, [headers: [Accept: "application/json"]]) do
			%HTTPotion.Response{status_code: code} when code == 400 -> raise "404 could not find: #{url}"
			%HTTPotion.Response{body: body} -> Poison.decode!(body)
			%HTTPotion.ErrorResponse{message: message} -> raise "Error fetching manifest: #{message}"
		end
	end

	defp serve_asset(conn = %Plug.Conn{path_info: [uri, file_name], req_headers: req_headers}, port, assets, manifest) do
		requested_path = "#{uri}/#{file_name}"
		actual_path = case manifest do
			%{^requested_path => value} -> value
			_ -> file_name
		end

		url = "http://localhost:#{port}"
		|> URI.merge(actual_path)
		|> URI.to_string

		asset_type = uri
		|> String.split("/")
		|> hd

		if Enum.any?(assets, &(&1 == asset_type)) do
			Http.get(url, [
				stream_to: self(),
				headers: req_headers
			])
			receive_response(conn)
		else
			conn
		end
	end

	defp serve_asset(conn = %Plug.Conn{}, _, _, _), do: conn

	defp receive_response(conn) do
		receive do
			%HTTPotion.AsyncChunk{chunk: chunk} ->
				case Conn.chunk(conn, chunk) do
					{:ok, conn} -> receive_response(conn)
					{:error, reason} -> raise reason
				end
			%HTTPotion.AsyncHeaders{status_code: status} when status == 404 -> conn
			%HTTPotion.AsyncHeaders{
				headers: %HTTPotion.Headers{hdrs: headers}
			} ->
				headers
				|> Map.to_list()
				|> Enum.reduce(conn, fn ({key, value}, acc) -> Conn.put_resp_header(acc, key, value) end)
				|> Conn.send_chunked(200)
				|> receive_response()
			%HTTPotion.AsyncEnd{} -> Conn.halt(conn)
			%HTTPotion.ErrorResponse{message: message} -> raise "Error fetching webpack resource: #{message}"
		after
			5_000 -> raise "Error fetching webpack resource: Timeout exceeded"
		end
	end
end
