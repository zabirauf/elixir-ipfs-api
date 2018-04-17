defmodule IpfsApi do
  @moduledoc """
  The module is a client to call into IPFS REST endpoint.

  """

  @type request_ret :: {:ok, Dict.t()} | {:error, String.t()}

  #########################
  ##### Basic Commands######
  #########################

  @spec add(IpfsConnection.t(), binary) :: request_ret
  def add(_connection, <<>>) do
    {:error, "No content provided"}
  end

  @doc ~S"""
  Add an object to ipfs

  ## Examples

      IpfsApi.add(%IpfsConnection{}, "Hello World")
  """
  @spec add(IpfsConnection.t(), binary) :: request_ret
  def add(connection, content) do
    connection
    |> create_url("/add")
    |> request_send_file(content)
  end

  @doc ~S"""
  Get an ipfs object

  ## Examples

      IpfsApi.get(%IpfsConnection{}, "QmUXTtySmd7LD4p6RG6rZW6RuUuPZXTtNMmRQ6DSQo3aMw")
  """
  @spec get(IpfsConnection.t(), String.t()) :: {:ok, binary} | {:error, String.t()}
  def get(connection, multihash) do
    connection
    |> create_url("/get/#{multihash}")
    |> request_get_file
  end

  @doc ~S"""
  Show ipfs object data
  """
  @spec cat(IpfsConnection.t(), String.t()) :: request_ret
  def cat(connection, multihash) do
    connection
    |> request(:get, "/cat", [multihash])
  end

  @doc ~S"""
  List links from an object
  """
  @spec ls(IpfsConnection.t(), String.t()) :: request_ret
  def ls(connection, multihash) do
    connection
    |> request(:get, "/ls", [multihash])
  end

  @doc ~S"""
  List hashes of links from an object
  """
  @spec refs(IpfsConnection.t(), String.t()) :: request_ret
  def refs(connection, multihash) do
    connection
    |> request(:get, "/refs", [multihash])
  end

  #########################
  # Data Structure Commands#
  #########################

  @doc ~S"""
  Print information of a raw IPFS block
  """
  @spec block_stat(IpfsConnection.t(), String.t()) :: request_ret
  def block_stat(connection, multihash) do
    connection
    |> request(:get, "/block/stat", [multihash])
  end

  @doc ~S"""
  Get a raw IPFS block
  """
  @spec block_get(IpfsConnection.t(), String.t()) :: request_ret
  def block_get(connection, multihash) do
    connection
    |> request(:get, "/block/get", [multihash])
  end

  @doc ~S"""
  Stores input as an IPFS block
  """
  @spec block_put(IpfsConnection.t(), binary) :: request_ret
  def block_put(connection, content) do
    connection
    |> create_url("/block/put")
    |> request_send_file(content)
  end

  @doc ~S"""
  The raw bytes in an IPFS object
  """
  @spec object_data(IpfsConnection.t(), String.t()) :: request_ret
  def object_data(connection, multihash) do
    connection
    |> request(:get, "/object/data", [multihash])
  end

  @doc ~S"""
  The links pointed to by the specified object
  """
  @spec object_links(IpfsConnection.t(), String.t()) :: request_ret
  def object_links(connection, multihash) do
    connection
    |> request(:get, "/object/links", [multihash])
  end

  @doc ~S"""
  Get and serialize the DAG node name by `multihash`
  """
  @spec object_get(IpfsConnection.t(), String.t()) :: request_ret
  def object_get(connection, multihash) do
    connection
    |> request(:get, "/object/get", [multihash])
  end

  @doc ~S"""
  Stores `content` as a DAG object
  """
  @spec object_put(IpfsConnection.t(), binary) :: request_ret
  def object_put(connection, content) do
    connection
    |> create_url("/block/put")
    |> request_send_file(content)
  end

  @doc ~S"""
  Get stats for the DAG node name by `key`
  """
  @spec object_stat(IpfsConnection.t(), String.t()) :: request_ret
  def object_stat(connection, key) do
    connection
    |> request(:get, "/object/stat", [key])
  end

  @doc ~S"""
  Create a new merkledag object base on an existing one
  """
  @spec object_patch(IpfsConnection.t(), String.t()) :: request_ret
  def object_patch(connection, key) do
    connection
    |> request(:get, "/object/patch", [key])
  end

  @doc ~S"""
  List directory content for `path`
  """
  @spec file_ls(IpfsConnection.t(), String.t()) :: request_ret
  def file_ls(connection, path) do
    connection
    |> request(:get, "/file/ls", [path])
  end

  #########################
  #### Advanced Commands####
  #########################

  @doc ~S"""
  Resolve the value of the `name`
  TODO: Add ability to resolve recursively
  """
  @spec resolve(IpfsConnection.t(), String.t()) :: request_ret
  def resolve(connection, name) do
    connection
    |> request(:get, "/resolve", [name])
  end

  @doc ~S"""
  Publish the `ipfs_path` to your identity name
  """
  @spec name_publish(IpfsConnection.t(), String.t()) :: request_ret
  def name_publish(connection, ipfs_path) do
    connection
    |> request(:get, "/name/publish", [ipfs_path])
  end

  @doc ~S"""
  Resolve the value of `name`
  """
  @spec name_resolve(IpfsConnection.t(), String.t()) :: request_ret
  def name_resolve(connection, name \\ "") do
    connection
    |> request(:get, "/name/resolve", [name])
  end

  @doc ~S"""
  Resolve the DNS link
  TODO: Add ability to resolve recursively
  """
  @spec dns(IpfsConnection.t(), String.t()) :: request_ret
  def dns(connection, domain_name) do
    connection
    |> request(:get, "/dns", [domain_name])
  end

  @doc ~S"""
  Pins objects to local storage
  """
  @spec pin_add(IpfsConnection.t(), String.t()) :: request_ret
  def pin_add(connection, ipfs_path) do
    connection
    |> request(:get, "/pin/add", [ipfs_path])
  end

  @doc ~S"""
  Remove the pinned object from local storage
  TODO: Add ability to resolve recursively
  """
  @spec pin_rm(IpfsConnection.t(), String.t()) :: request_ret
  def pin_rm(connection, ipfs_path) do
    connection
    |> request(:get, "/pin/rm", [ipfs_path])
  end

  @doc ~S"""
  List objects pinned to local storage
  """
  @spec pin_ls(IpfsConnection.t()) :: request_ret
  def pin_ls(connection) do
    connection
    |> request(:get, "/pin/ls", [])
  end

  @doc ~S"""
  Perform a grabage collection sweep on the repo
  """
  @spec repo_gc(IpfsConnection.t()) :: request_ret
  def repo_gc(connection) do
    connection
    |> request(:get, "/repo/gc", [])
  end

  #########################
  #### Network Commands#####
  #########################

  @doc ~S"""
  Gets the information about the specified `peer_id`
  """
  @spec id(IpfsConnection.t(), String.t()) :: request_ret
  def id(connection, peer_id \\ "") do
    connection
    |> request(:get, "/id", [peer_id])
  end

  @doc ~S"""
  Gets the list of bootstrap peers
  """
  @spec bootstrap(IpfsConnection.t()) :: request_ret
  def bootstrap(connection) do
    connection
    |> request(:get, "/bootstrap", [])
  end

  @doc ~S"""
  Add peers to the bootstrap list
  """
  @spec bootstrap_add(IpfsConnection.t(), String.t()) :: request_ret
  def bootstrap_add(connection, peer) do
    connection
    |> request(:get, "/bootstrap/add", [peer])
  end

  @doc ~S"""
  Remoes peers from the bootstrap list
  """
  @spec bootstrap_rm(IpfsConnection.t(), String.t()) :: request_ret
  def bootstrap_rm(connection, peer) do
    connection
    |> request(:get, "/bootstrap/rm", [peer])
  end

  @doc ~S"""
  List peers with open connections
  """
  @spec swarm_peers(IpfsConnection.t()) :: request_ret
  def swarm_peers(connection) do
    connection
    |> request(:get, "/swarm/peers", [])
  end

  @doc ~S"""
  List known addresses
  """
  @spec swarm_addr(IpfsConnection.t()) :: request_ret
  def swarm_addr(connection) do
    connection
    |> request(:get, "/swarm/addrs", [])
  end

  @doc ~S"""
  Open connection to given `address`
  """
  @spec swarm_connect(IpfsConnection.t(), String.t()) :: request_ret
  def swarm_connect(connection, address) do
    connection
    |> request(:get, "/swarm/connect", [address])
  end

  @doc ~S"""
  Close connection to give address
  """
  @spec swarm_disconnect(IpfsConnection.t(), String.t()) :: request_ret
  def swarm_disconnect(connection, address) do
    connection
    |> request(:get, "/swarm/disconnect", [address])
  end

  @doc ~S"""
  Add an address filter
  """
  @spec swarm_filters_add(IpfsConnection.t(), String.t()) :: request_ret
  def swarm_filters_add(connection, address) do
    connection
    |> request(:get, "/swarm/filters/add", [address])
  end

  @doc ~S"""
  Remove an address filter
  """
  @spec swarm_filters_rm(IpfsConnection.t(), String.t()) :: request_ret
  def swarm_filters_rm(connection, address) do
    connection
    |> request(:get, "/swarm/filters/rm", [address])
  end

  @doc ~S"""
  Run a FindClosesPeers query through the DHT
  """
  @spec dht_query(IpfsConnection.t(), String.t()) :: request_ret
  def dht_query(connection, peer_id) do
    connection
    |> request(:get, "/dht/query", [peer_id])
  end

  @doc ~S"""
  Run a FundProviders quest through the DHT
  """
  @spec dht_findprovs(IpfsConnection.t(), String.t()) :: request_ret
  def dht_findprovs(connection, key) do
    connection
    |> request(:get, "/dht/findprovs", [key])
  end

  @doc ~S"""
  Run a FindPeer query through the DHT
  """
  @spec dht_findpeer(IpfsConnection.t(), String.t()) :: request_ret
  def dht_findpeer(connection, peer_id) do
    connection
    |> request(:get, "/dht/findpeer", [peer_id])
  end

  @doc ~S"""
  Run a GetValue query through the DHT
  """
  @spec dht_get(IpfsConnection.t(), String.t()) :: request_ret
  def dht_get(connection, key) do
    connection
    |> request(:get, "/dht/get", [key])
  end

  @doc ~S"""
  Run a PutValue query through the DHT
  """
  @spec dht_put(IpfsConnection.t(), String.t(), String.t()) :: request_ret
  def dht_put(connection, key, value) do
    connection
    |> request(:get, "/dht/put", [key, value])
  end

  @doc ~S"""
  Send echo request packets to IPFS hosts
  TODO: Add ability to give number of count
  """
  @spec ping(IpfsConnection.t(), String.t()) :: request_ret
  def ping(connection, peer_id) do
    connection
    |> request(:get, "/ping", [peer_id])
  end

  #########################
  ###### Tool Commands######
  #########################

  # def config() do
  @doc ~S"""
  Gets the content of the config file
  """
  @spec config_show(IpfsConnection.t()) :: request_ret
  def config_show(connection) do
    connection
    |> request(:get, "/config/show", [])
  end

  # def config_replace() do

  @doc ~S"""
  Gets the IPFS version
  """
  @spec version(IpfsConnection.t()) :: request_ret
  def version(connection) do
    connection
    |> request(:get, "/version", [])
  end

  #########################
  #### Helper Functions#####
  #########################

  defp create_url(connection, path) do
    "#{connection.host}:#{connection.port}/#{connection.base}#{path}"
  end

  defp request_send_file(url, content) do
    url
    |> (fn url ->
          boundary = "a831rwxi1a3gzaorw1w2z49dlsor"

          HTTPoison.request(:post, url, create_add_body(content, boundary), [
            {"Content-Type", "multipart/form-data; boundary=#{boundary}"}
          ])
        end).()
    |> process_response
  end

  defp request_get_file(url) do
    url
    |> HTTPoison.get()
    |> process_response(& &1)
  end

  defp request(connection, req_type, path, args) do
    request_internal(connection, req_type, create_url(connection, path), args)
  end

  defp request_internal(_connection, :post, url, %{} = args) do
    url
    |> HTTPoison.post(Poison.encode(args))
    |> process_response
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

  defp process_response(
         {:ok, %HTTPoison.Response{status_code: 200, body: body}},
         deserializationFunc
       ) do
    deserializationFunc.(body)
  end

  defp process_response(
         {:ok, %HTTPoison.Response{status_code: code, body: body}},
         _deserializationFunc
       ) do
    {:error, "Error status code: #{code}, #{body}"}
  end

  defp process_response({:error, %HTTPoison.Error{reason: reason}}, _deserializationFunc) do
    {:error, reason}
  end

  defp create_add_body(content, boundary) do
    "--#{boundary}\r\nContent-Type: application/octet-stream\r\nContent-Disposition: file; \r\n\r\n#{
      content
    }    #{boundary}"
  end
end
