defmodule IpfsApi do
  @moduledoc """

  """

  @type request_ret :: {:ok, Dict.t} | {:error, String.t}

  defp request(connection, req_type, path, args) do
    request_internal(connection, req_type, "#{connection.host}:#{connection.port}/#{connection.base}#{path}", args)
  end

  defp request_internal(connection, :get, url, []) do
    HTTPoison.get(url)
    |> process_response
  end

  defp request_internal(connection, :get, url, [h | t]) do
    request(connection, :get, "#{url}/#{h}", t)
  end

  defp process_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    Poison.decode(body)
  end

  defp process_response({:ok, %HTTPoison.Response{status_code: code, body: body}}) do
    {:error, "Error status code: #{code}, #{body}"}
  end

  defp process_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end

  #########################
  #####Basic Commands######
  #########################

  def add(conection, fileStream) do
  end

  def get(connection, multihash) do
  end

  @spec cat(IpfsConnection.t, String.t) :: request_ret
  def cat(connection, multihash) do
    connection
    |> request(:get, "/cat", [multihash])
  end

  @spec ls(IpfsConnection.t, String.t) :: request_ret
  def ls(connection, multihash) do
    connection
    |> request(:get, "/ls", [multihash])
  end

  @spec refs(IpfsConnection.t, String.t) :: request_ret
  def refs(connection, multihash) do
    connection
    |> request(:get, "/refs", [multihash])
  end

  @spec block_stat(IpfsConnection.t, String.t) :: request_ret
  def block_stat(connection, multihash) do
    connection
    |> request(:get, "/block/stat", [multihash])
  end

  @spec block_get(IpfsConnection.t, String.t) :: request_ret
  def block_get(connection, multihash) do
    connection
    |> request(:get, "/block/get", [multihash])
  end

  @spec block_put(IpfsConnection.t, String.t) :: request_ret
  def block_put(connection, multihash) do
  end

  @spec object_data(IpfsConnection.t, String.t) :: request_ret
  def object_data(connection, multihash) do
    connection
    |> request(:get, "/object/data", [multihash])
  end

  @spec object_links(IpfsConnection.t, String.t) :: request_ret
  def object_links(connection, multihash) do
    connection
    |> request(:get, "/object/links", [multihash])
  end

  @spec object_get(IpfsConnection.t, String.t) :: request_ret
  def object_get(connection, multihash) do
    connection
    |> request(:get, "/object/get", [multihash])
  end

  def object_put() do
  end

  @spec object_stat(IpfsConnection.t, String.t) :: request_ret
  def object_stat(connection, multihash) do
    connection
    |> request(:get, "/object/stat", [multihash])
  end

  @spec object_patch(IpfsConnection.t, String.t) :: request_ret
  def object_patch(connection, multihash) do
    connection
    |> request(:get, "/object/patch", [multihash])
  end

  @spec file_ls(IpfsConnection.t, String.t) :: request_ret
  def file_ls(connection, multihash) do
    connection
    |> request(:get, "/file/ls", [multihash])
  end

  # def resolve() do
  # def name_publish() do
  # def name_resolve() do
  # def dns() do
  # def pin_add() do
  # def pin_rm() do
  # def pin_ls() do
  # def repo_gc() do

  @spec id(IpfsConnection.t) :: request_ret
  def id(connection) do
    connection
    |> request(:get, "/id", [])
  end

  # def bootstrap() do
  # def bootstrap_add() do
  # def bootstrap_rm() do
  # def swarm_peers() do
  # def swarm_addr() do
  # def swarm_connect() do
  # def swarm_disconnect() do
  # def swarm_filters_add() do
  # def swarm_filters_rm() do
  # def dht_query() do
  # def dht_findprovs() do
  # def dht_findpeer() do
  # def dht_get() do
  # def dht_put() do
  # def ping() do
  # def config() do
  # def config_show() do
  # def config_replace() do
  # def version() do

end
