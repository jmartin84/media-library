defmodule Medialibrary.ElasticSearch do
  @moduledoc "Exposes functions to query and malipulate data in elastic search"
  alias Medialibrary.Http, as: Http

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
  def search(term \\ "") do
    url = Application.get_env(:medialibrary, :elastic_search) <> "/media/_search"

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

    results = Http.post(url, query)

    case results do
      {:ok, %{"error" => err, "status" => code}} -> {:error, %{:msg => err, :code => code}}
      {:ok, %{:data => data}} -> map_search_results(Poison.decode(data))
      {:error, data} -> {:error, data}
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

  defp map_search_results({:ok, _}), do: []
end
