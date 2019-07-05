defmodule CoinbaseApp.Client do
  use WebSockex

  @url "wss://ws-feed.pro.coinbase.com"

  def start_link(products \\ []) do
    {:ok, pid} = WebSockex.start_link(@url, __MODULE__, :no_state)
    subscribe(pid, products)
    {:ok, pid}
  end

  @doc """
  A callback called when client is connected
  """
  def handle_connect(conn, state) do
    IO.puts("connected!")
    {:ok, state}
  end

  @doc """
  Once subscribed coinbase server start sending a msg, 
  hence a callback method once client receives the data
  """
  def handle_frame(_frame={:text, msg}, state) do
    msg
      |> Poison.decode!()
      |> IO.inspect()
      { :ok, state }
  end

  @doc """
  builds a subscription frame and sends it to
  the server where the pid is websocket client process pid
  """
  def subscribe(pid, products) do
    WebSockex.send_frame pid, subscription_frame(products)
  end

  @doc """
  returns a frame ready to be sent to the server
  products is a list of coinbase product ids i.e strings
  `BTC-USD`, `ETH-USD`
  """
  defp subscription_frame(products) do
    subscription_msg = %{
      type: "subscribe",
      product_ids: products,
      channels: ["full"] 
    } |> Poison.encode!()
    
    {:text, subscription_msg}
  end

end
