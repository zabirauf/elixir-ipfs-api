defmodule IpfsApi do
  @moduledoc """
  The module is a client to call into IPFS REST endpoint.

  """

  @type request_ret :: {:ok, Dict.t} | {:error, String.t}

  #########################
  #####Basic Commands######
  #########################

  @spec add(IpfsConnection.t, binary) :: request_ret
  def add(_connection, <<>>) do
    {:error, "No content provided"}
  end

  @spec add(IpfsConnection.t, binary) :: request_ret
  def add(connection, content) do
    connection
    |> create_url("/add")
    |> request_send_file(content)
  end

  @spec cat(IpfsConnection.t, String.t) :: {:ok, binary} | {:error, String.t}
  def get(connection, multihash) do
    connection
    |> create_url("/get/#{multihash}")
    |> request_get_file
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

  #########################
  #Data Structure Commands#
  #########################

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

  @spec block_put(IpfsConnection.t, binary) :: request_ret
  def block_put(connection, content) do
    connection
    |> create_url("/block/put")
    |> request_send_file(content)
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

  @spec object_put(IpfsConnection.t, binary) :: request_ret
  def object_put(connection, content) do
    connection
    |> create_url("/block/put")
    |> request_send_file(content)
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

  #########################
  ####Advanced Commands####
  #########################

  # def resolve() do
  # def name_publish() do
  # def name_resolve() do
  # def dns() do
  # def pin_add() do
  # def pin_rm() do
  # def pin_ls() do
  # def repo_gc() do

  #########################
  ####Network Commands#####
  #########################

  @spec id(IpfsConnection.t) :: request_ret
  def id(connection) do
    connection
    |> request(:get, "/id", [])
  end

  @spec bootstrap(IpfsConnection.t) :: request_ret
  def bootstrap(connection) do
    connection
    |> request(:get, "/bootstrap", [])
  end

  # def bootstrap_add() do
  # def bootstrap_rm() do

  @spec swarm_peers(IpfsConnection.t) :: request_ret
  def swarm_peers(connection) do
    connection
    |> request(:get, "/swarm/peers", [])
  end

  @spec swarm_addr(IpfsConnection.t) :: request_ret
  def swarm_addr(connection) do
    connection
    |> request(:get, "/swarm/addrs", [])
  end

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

  #########################
  ######Tool Commands######
  #########################

  # def config() do

  @spec config_show(IpfsConnection.t) :: request_ret
  def config_show(connection) do
    connection
    |> request(:get, "/config/show", [])
  end

  # def config_replace() do

  @spec version(IpfsConnection.t) :: request_ret
  def version(connection) do
    connection
    |> request(:get, "/version", [])
  end

  #########################
  ####Helper Functions#####
  #########################

  defp create_url(connection, path) do
    "#{connection.host}:#{connection.port}/#{connection.base}#{path}"
  end

  defp request_send_file(url, content) do
    url
    |> (fn(url) ->
      boundary = "a831rwxi1a3gzaorw1w2z49dlsor"
      HTTPoison.request(:post, url, create_add_body(content, boundary), [
            {"Content-Type", "multipart/form-data; boundary=#{boundary}"}])
    end).()
    |> process_response
  end

  defp request_get_file(url) do
    url
    |> HTTPoison.get
    |> process_response(&(&1))
  end

  defp request(connection, req_type, path, args) do
    request_internal(connection, req_type, create_url(connection, path), args)
  end

  defp request_internal(_connection, :get, url, []) do
    HTTPoison.get(url)
    |> process_response
  end

  defp request_internal(connection, :get, url, [h | t]) do
    request(connection, :get, "#{url}/#{h}", t)
  end

  defp process_response(response) do
    process_response(response, &Poison.decode/1)
  end

  defp process_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}, deserializationFunc) do
    deserializationFunc.(body)
  end

  defp process_response({:ok, %HTTPoison.Response{status_code: code, body: body}}, _deserializationFunc) do
    {:error, "Error status code: #{code}, #{body}"}
  end

  defp process_response({:error, %HTTPoison.Error{reason: reason}}, _deserializationFunc) do
    {:error, reason}
  end

  defp create_add_body(content, boundary) do
    "--#{boundary}\r\nContent-Type: application/octet-stream\r\nContent-Disposition: file; \r\n\r\n#{content}    #{boundary}"
  end

end
