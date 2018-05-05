defmodule MedialibraryWeb.Webpack_Static do
	alias Medialibrary.Http, as: Http
	alias Plug.Conn, as: Conn

	def init([port, webpack_assets | static_plug_opts]) do
		Plug.Static.init(static_plug_opts)
		[port, webpack_assets, {:static_plug_opts, static_plug_opts}]
	end

	def call(conn, [
		{:port, port},
		{:webpack_assets, assets},
		{:static_plug_opts, static_opts}
	]) do
		if Mix.env == :dev do
			serve_asset conn, port, assets
		else
			bypass_webpack conn, static_opts
		end
	end

	defp serve_asset(conn = %Plug.Conn{path_info: [uri, file_name], req_headers: headers}, port, assets) do
		url = "http://localhost:#{port}"
			|> URI.merge(uri)
			|> URI.merge(file_name)
			|> URI.to_string

		asset_type = uri
			|> String.split("/")
			|> hd

		if Enum.any?(assets, &(&1 == asset_type)) do
			{content_type, data} = request_webpack_asset(url, headers)

			conn
				|> Conn.put_resp_content_type(content_type)
				|> Conn.send_resp(200, data)
				|> Conn.halt()
		else
			conn
		end
	end

	defp serve_asset(conn = %Plug.Conn{}, _, _), do: conn

	defp request_webpack_asset(path, headers) do

	end

	defp bypass_webpack(conn, opts) do
		Plug.Static.call conn, opts
	end
end
