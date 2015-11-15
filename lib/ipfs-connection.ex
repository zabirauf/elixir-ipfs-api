defmodule IpfsConnection do

  @type t :: %IpfsConnection{host: String.t, base: String.t, port: pos_integer}
  defstruct host: "localhost", base: "api/v0", port: 5001

end
