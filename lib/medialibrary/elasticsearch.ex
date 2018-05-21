defmodule Medialibrary.ElasticSearch do
  @moduledoc "Exposes functions to query and malipulate data in elastic search"

  @http Application.get_env(:medialibrary, :http)
  @base_url Application.get_env(:medialibrary, :elastic_search)

  @doc """
  	This function is used to search the medial library index for a given term.

  	It searches the following fields:
  		* Media name
  		* director.firstName
  		* director.lastName
  		* cast.firstName
  		* cast.lastName

  	Returns `{:ok, results}` for success and `{:error, msg}` on failure
  """

  @spec search(String.t()) :: {:ok, [Map]} | {:error, Map}
  def search(term \\ "") do
    url = @base_url <> "/media/_search"

    query =
      if term == "" do
        %{}
      else
        %{
          :query => %{
            :bool => %{
              :should => [
                %{:match => %{:name => term}},
                %{:match => %{"director.firstName" => term}},
                %{:match => %{"director.lastName" => term}},
                %{
                  :nested => %{
                    :path => "cast",
                    :query => %{
                      :bool => %{
                        :should => [
                          %{:match => %{"cast.firstName" => term}},
                          %{:match => %{"cast.lastName" => term}}
                        ]
                      }
                    }
                  }
                }
              ]
            }
          }
        }
      end

    results = @http.post(url, query)

    case results do
      {:ok, %{"error" => err, "status" => code}} ->
        {:error, %{:msg => err, :status => code}}

      {:ok, %{:data => data}} ->
        results =
          data
          |> Poison.decode()
          |> map_search_results()

        {:ok, results}

      {:error, data} ->
        {:error, data}
    end
  end

  defp map_search_results({:ok, %{"hits" => %{"hits" => results}}}) do
    map_result = fn %{"_id" => id, "_source" => source} ->
      map_items = fn item, key ->
        item
        |> Map.get(key)
        |> Enum.map(& &1["name"])
        |> (&Map.put(item, key, &1)).()
      end

      source
      |> map_items.("tags")
      |> map_items.("source")
      |> map_items.("type")
      |> Map.put("id", id)
    end

    Enum.map(results, &map_result.(&1))
  end

  defp map_search_results(error = {:error, _}), do: error
end
