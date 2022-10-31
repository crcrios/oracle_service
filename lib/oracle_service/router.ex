defmodule OracleService.Router do
  # Bring Plug.Router module into scope
  use Plug.Router

  # Attach the Logger to log incoming requests
  plug(Plug.Logger)

  # Tell Plug to match the incoming request with the defined endpoints
  plug(:match)

  # Once there is a match, parse the response body if the content-type
  # is application/json. The order is important here, as we only want to
  # parse the body if there is a matching route.(Using the Jayson parser)
  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  # Dispatch the connection to the matched handler
  plug(:dispatch)

  # Handler for GET request with "/" path
  get "/" do
    IO.puts "Entro al GET"
    response1 = OracleService.Request.getResponseCoinMarketCap("MATIC","COP")
    response2 = OracleService.Request.getResponseCoinMarketCap("MATIC","USD")
    response3 = OracleService.Request.getResponseCoinMarketCap("MATIC","ETH")
    response4 = OracleService.Request.getResponseCryptoCompare("MATIC","COP")
    response5 = OracleService.Request.getResponseCryptoCompare("MATIC","USD")
    response6 = OracleService.Request.getResponseCryptoCompare("MATIC","ETH")


  output = "{
    \"CoinMarketCap\" : {
       \"MATIC -> COP \" : #{Float.round(response1, 5)},
       \"MATIC -> USD \" : #{Float.round(response2, 5)},
       \"MATIC -> ETH \" : #{Float.round(response3, 5)},
      },
     \"CryptoCompare \" : {
       \"MATIC -> COP \" : #{Float.round(response4, 5)},
       \"MATIC -> USD \" : #{Float.round(response5, 5)},
       \"MATIC -> ETH \" : #{Float.round(response6, 5)},
    },
  }"

    IO.puts response1
    IO.puts response2
    IO.puts response3
    IO.puts response4
    IO.puts response5
    IO.puts response6
    send_resp(conn, 200, output)
  end

  # Fallback handler when there was no match
  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
