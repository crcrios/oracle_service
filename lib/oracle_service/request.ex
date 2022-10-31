defmodule OracleService.Request do

  def getResponseCoinMarketCap(from, to) do
    headers = [{:"X-CMC_PRO_API_KEY", "a65c171c-2670-4867-9c64-ae19276610dd"}]
    url = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?convert=#{to}&symbol=#{from}"
    result = getResponse(url, headers)
    if (result != nil) do
      result["data"]["MATIC"]["quote"][to]["price"]
    end
  end

  def getResponseCryptoCompare(from, to) do
    headers = [{:"authorization", "Apikey 0286f382c86e6bcc6597c91943d2b40fce998d01de972275e211cb6320d7c0a0"}]
    url = "https://min-api.cryptocompare.com/data/price?fsym=#{from}&tsyms=#{to}"
    result = getResponse(url, headers)
    if (result != nil) do
      result[to]
    end
  end

  defp getResponse(url, headers) do
    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.Parser.parse!(body)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
        nil
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
        nil
      true ->
        IO.puts "Not found :("
        nil
    end
  end

end
