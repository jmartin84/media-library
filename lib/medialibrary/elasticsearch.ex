defmodule Medialibrary.ElasticSearch do
	alias Medialibrary.Http, as: Http

	def search(term \\ "") do
		query = if term == "" do
			%{}
		else
			%{:query => %{:bool => %{:should => [
				%{:match => %{:name => term}},
				%{:match => %{"director.firstName" => term}},
				%{:match => %{"director.lastName" => term}},
				%{
					:nested => %{
						:path => "cast",
						:query => %{:bool => %{:should => [
							%{:match => %{"cast.firstName" => term}},
							%{:match => %{"cast.lastName" => term}}
						]}}
					}
				}
			]}}}
		end

		handle_response = fn response ->
			response
			|> case do
				{:ok, %{"error" => err, "status" => code}} -> {:error, %{:msg => err, :code => code}}
				{:ok, results} -> map_search_results({:ok, results})
				{_} -> {:error, %{:msg => "error json decoding es response"}}
			end
		end

		Http.post("/media/_search", query, handle_response)
	end

	defp map_search_results({:ok, %{"hits" => %{"hits" => results}}}) do
		map_result = fn (%{"_id"=> id, "_source"=> source}) ->
			map_items = fn item, key ->
				Map.get(item, key)
				|> Enum.map(&(&1["name"]))
				|> (&(Map.put(item, key, &1))).()
			end

			source
			|> map_items.("tags")
			|> map_items.("source")
			|> map_items.("type")
			|> Map.put("id", id)
		end

		Enum.map(results, &(map_result.(&1)))
	end

	defp map_search_results({:ok, _}), do: []
end
