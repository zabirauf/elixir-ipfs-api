[![Build Status](https://travis-ci.org/zabirauf/elixir-ipfs-api.svg)](https://travis-ci.org/zabirauf/elixir-ipfs-api) [![Inline docs](http://inch-ci.org/github/zabirauf/elixir-ipfs-api.svg)](http://inch-ci.org/github/zabirauf/elixir-ipfs-api)

Current Version: [v0.1.0](https://hex.pm/packages/elixir_ipfs_api)

# Elixir-Ipfs-Api

The Elixir library that is used to communicate with the IPFS REST endpoint.

![elixir_ipfs_api](https://cloud.githubusercontent.com/assets/1104560/11236786/a332e2ba-8d90-11e5-9b21-e37a0931130c.png)

# [Documentation](http://hexdocs.pm/elixir_ipfs_api/)

The documentation is posted at [hexdocs](http://hexdocs.pm/elixir_ipfs_api/)

# How to use it

## 1. Add the library to mix.exs

The package is published on [Hex](https://hex.pm). Add the elixir\_ipfs\_api as follow

```elixir
defp deps do
    [
        ...
        {:elixir_ipfs_api, "~> 0.1.0"}
        ...
    ]
end
```

## 2. Start the IPFS Daemon

Start the IPFS daemon by running the following in terminal

```bash
$ ipfs daemon
```

This will start the ipfs daemon with the API endpoint at localhost:5001.
If you want to start the API endpoint at a different address then add to the config

```bash
$ ipfs config Addresses.API /ipfs/127.0.0.1/tcp/5007
```

## 3. Create the IpfsConnection in your code

The [IpfsConnection](http://hexdocs.pm/elixir_ipfs_api/IpfsConnection.html) entity contains the information of the IPFS API endpoint. By default it will try to connect to http://localhost:5001/api/v0

```elixir
conn = %IpfsConnection{host: "127.0.0.1", base: "api/v0", port: 5007}
```

## Examples

### Adding content to IPFS


```elixir
iex> conn = %IpfsConnection{}
iex> IpfsApi.add(conn, "Hello world from Elixir-Ipfs-Api")
{:ok,
 %{"Hash" => "QmTcCZJEW1kUcYU1bKQk9SMGRsTisMMWXuxJ1AQerHwyaA",
 "Name" => "QmTcCZJEW1kUcYU1bKQk9SMGRsTisMMWXuxJ1AQerHwyaA"}}
 ```

### Getting content from IPFS


```elixir
iex> conn = %IpfsConnection{}
iex> IpfsApi.get(conn, "QmTcCZJEW1kUcYU1bKQk9SMGRsTisMMWXuxJ1AQerHwyaA")
<<81, 109, 84, 99, 67, 90, 74, 69, 87, 49, 107, 85, 99, 89, 85, 49, 98, 75, 81, 107, 57, 83, 77, 71, 82, 115, 84, 105, 115, 77, 77, 87, 88, 117, 120, 74, 49, 65, 81, 101, 114, 72, 119, 121, 97, 65, 0, 0, 0, 0, ...>>
```

# TODO
- [] Add stream for adding & getting files to and from IPFS
- [] Add a pool to request from multiple different IPFS nodes

