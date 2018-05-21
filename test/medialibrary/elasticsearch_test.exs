defmodule Medialibrary.ElasticSearchTest do
  @moduledoc false
  use ExUnit.Case
  import Mox
  alias Medialibrary.ElasticSearch, as: ElasticSearch

  @successful_http_result {:ok,
                           %{
                             data:
                               "{\"took\":8,\"timed_out\":false,\"_shards\":{\"total\":5,\"successful\":5,\"skipped\":0,\"failed\":0},\"hits\":{\"total\":1,\"max_score\":0.2876821,\"hits\":[{\"_index\":\"media_20180416\",\"_type\":\"_doc\",\"_id\":\"1JbuemMB7vHxFNIX4shV\",\"_score\":0.2876821,\"_source\":{\n\t\"cast\":[{\n\t\t\"firstName\": \"Josue\",\n\t\t\"lastName\": \"quevo\"\n\t}, {\n\t\t\"firstName\":\"James\",\n\t\t\"lastName\": \"Goodwin\"\n\t}],\n\t\"director\": {\n\t\t\"firstName\": \"George\",\n\t\t\"lastName\": \"Lucas\"\n\t},\n\t\"name\":\"movie 1\",\n\t\"rating\":\".5\",\n\t\"imageUrl\":\"https://dummyimage.com/300x250/000/fff\",\n\t\"releasedOn\":\"2018-04-04\",\n\t\"source\":[{\"name\":\"Netflix\"}, {\"name\":\"Amazon Prime\"}],\n\t\"tags\":[{\"name\":\"Comedy\"}],\n\t\"type\":[{\"name\":\"Movie\"}]\n\t\n}}]}}"
                           }}

  @expected_successful_response {:ok,
                                 [
                                   %{
                                     "cast" => [
                                       %{"firstName" => "Josue", "lastName" => "quevo"},
                                       %{"firstName" => "James", "lastName" => "Goodwin"}
                                     ],
                                     "director" => %{
                                       "firstName" => "George",
                                       "lastName" => "Lucas"
                                     },
                                     "id" => "1JbuemMB7vHxFNIX4shV",
                                     "imageUrl" => "https://dummyimage.com/300x250/000/fff",
                                     "name" => "movie 1",
                                     "rating" => ".5",
                                     "releasedOn" => "2018-04-04",
                                     "source" => ["Netflix", "Amazon Prime"],
                                     "tags" => ["Comedy"],
                                     "type" => ["Movie"]
                                   }
                                 ]}

  setup :verify_on_exit!

  test "should be able to return results for a search term" do
    Medialibrary.HttpMock
    |> expect(:post, fn _, _ -> @successful_http_result end)

    result = ElasticSearch.search("lucas")

    assert result == @expected_successful_response
  end

  test "should return error when elasticsearch returns an error" do
    Medialibrary.HttpMock
    |> expect(:post, fn _, _ -> {:ok, %{"error" => "I failed", "status" => 405}} end)

    result = ElasticSearch.search("lucas")
    assert result == {:error, %{status: 405, msg: "I failed"}}
  end

  test "should return error when the http request returns an error" do
    Medialibrary.HttpMock
    |> expect(:post, fn _, _ -> {:error, %{:msg => "I failed", :status => 500}} end)

    result = ElasticSearch.search("lucas")
    assert result == {:error, %{status: 500, msg: "I failed"}}
  end
end
