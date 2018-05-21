defmodule Medialibrary.HttpBehavior do
  @moduledoc """
  Defines the behaviors for the http module
  """
  @callback get(String.t(), []) :: {:ok, [Map]} | {:ok, Map} | {:error, Map}
  @callback post(String.t(), Map) :: {:ok, [Map]} | {:ok, Map} | {:error, Map}
end
