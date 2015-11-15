defmodule IpfsClient do
  use HTTPoison.Base

  @expected_fields ~w(
  ID PublicKey Addresses AgentVersion ProtocolVersion
  )

  def process_url(url) do
    url
  end

  def process_response_body(body) do
    body
    |> Poison.decode
    |> Dict.take(@expected_fields)
    |> Enum.map(fn({k,v}) -> {String.to_atom(k), v} end)
  end
end
