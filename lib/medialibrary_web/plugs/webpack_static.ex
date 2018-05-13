defmodule MedialibraryWeb.Webpack_Static do
	alias Medialibrary.Http, as: Http
	alias Plug.Conn, as: Conn
	require Poison
	require Logger

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
			manifest = case manifest_path do
				path when is_binary(path) -> get_manifest(path, port)
				_ -> nil
			end

			serve_asset conn, port, assets, manifest
		else
			conn
		end
	end

	defp get_manifest(path, port) do
		url = "http://localhost:#{port}"
		|> URI.merge(path)
		|> URI.to_string()

		case Http.get(url, [Accept: "application/json"]) do
			{:error, %{:status => code}} when code == 404 -> raise "404 could not find " <> url
			{:error, _} -> raise "Unable able to fetch wepback manifest"
			{:ok, %{:data => data}} -> Poison.decode!(data)
		end
	end

	defp serve_asset(conn = %Plug.Conn{path_info: [uri, file_name], req_headers: req_headers}, port, assets, manifest) do
		requested_path = uri <> "/" <> file_name
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
			webpack_response = Http.get(url, [])

			case webpack_response do
				{:error, %{:status => status}} when status == 404 -> conn
				{:error, %{:msg => msg}} -> raise msg
				{:ok, %{
					:data => data,
					:headers => resp_headers,
					:status => status
				}} -> resp_headers
					|> Map.to_list()
					|> Enum.reduce(conn, fn ({name, value}, acc) ->
						Conn.put_resp_header(acc, name, value)
					end)
					|> Conn.send_resp(status, data)
					|> Conn.halt()
			end
		else
			conn
		end
	end

	defp serve_asset(conn = %Plug.Conn{}, _, _, _), do: conn

	defp bypass_webpack(conn, opts) do
		Plug.Static.call conn, opts
	end
end
