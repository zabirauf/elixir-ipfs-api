[![Build Status](https://travis-ci.org/zabirauf/elixir-ipfs-api.svg)](https://travis-ci.org/zabirauf/elixir-ipfs-api) | [![Inline docs](http://inch-ci.org/github/zabirauf/elixir-ipfs-api.svg)](http://inch-ci.org/github/zabirauf/elixir-ipfs-api)


# Elixir-Ipfs-Api

The Elixir library that is used to communicate with the IPFS REST endpoint.

# Examples

## Getting the version of IPFS node

```
iex> conn = %IpfsConnection{}
iex> IpfsApi.version(conn)
{:ok, %{"Commit" => "", "Repo" => "2", "Version" => "0.3.10-dev"}}
```

## Adding content to IPFS

```
iex> conn = %IpfsConnection{}
iex> IpfsApi.add(conn, "Hello world from Elixir-Ipfs-Api")
{:ok,
 %{"Hash" => "QmTcCZJEW1kUcYU1bKQk9SMGRsTisMMWXuxJ1AQerHwyaA",
 "Name" => "QmTcCZJEW1kUcYU1bKQk9SMGRsTisMMWXuxJ1AQerHwyaA"}}
 ```

## Getting content from IPFS

```
iex> conn = %IpfsConnection{}
iex> IpfsApi.get(conn, "QmTcCZJEW1kUcYU1bKQk9SMGRsTisMMWXuxJ1AQerHwyaA")
<<81, 109, 84, 99, 67, 90, 74, 69, 87, 49, 107, 85, 99, 89, 85, 49, 98, 75, 81, 107, 57, 83, 77, 71, 82, 115, 84, 105, 115, 77, 77, 87, 88, 117, 120, 74, 49, 65, 81, 101, 114, 72, 119, 121, 97, 65, 0, 0, 0, 0, ...>>
```

## Available APIs

### Basic commands
1. add
2. get
3. cat
4. ls
5. refs

### Data structure commands
1. block_stat
2. block_get
3. block_put
4. object_data
5. object_links
6. object_get
7. object_put
8. object_stat
9. object_patch
10. file_ls

### Network commands
1. id
2. bootstrap
3. swarm_peers
4. swarm_addr

### Tool commands
1. config_show
2. version

# TODO
* Complete Advanced commands, networks commands & tool commands APIs
* Add stream for adding & getting files to and from IPFS
* Add a pool to request from multiple different IPFS nodes

