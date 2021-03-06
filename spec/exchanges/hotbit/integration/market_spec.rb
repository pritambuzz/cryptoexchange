require 'spec_helper'

RSpec.describe 'Hotbit Coin integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:eng_eth_pair) { Cryptoexchange::Models::MarketPair.new(base: 'ENG', target: 'ETH', market: 'hotbit') }

  it 'fetch pairs' do
    pairs = client.pairs('hotbit')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'hotbit'
  end

  it 'give trade url' do
    trade_page_url = client.trade_page_url 'hotbit', base: eng_eth_pair.base, target: eng_eth_pair.target
    expect(trade_page_url).to eq "https://www.hotbit.io/exchange?symbol=ENG_ETH"
  end

  it 'fetch ticker' do
    ticker = client.ticker(eng_eth_pair)

    expect(ticker.base).to eq 'ENG'
    expect(ticker.target).to eq 'ETH'
    expect(ticker.market).to eq 'hotbit'
    expect(ticker.last).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.low).to be_a Numeric
    expect(ticker.bid).to be_a Numeric
    expect(ticker.ask).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be nil
    expect(ticker.payload).to_not be nil
  end

  it 'fetch order book' do
    order_book = client.order_book(eng_eth_pair)

    expect(order_book.base).to eq 'ENG'
    expect(order_book.target).to eq 'ETH'
    expect(order_book.market).to eq 'hotbit'

    expect(order_book.asks).to_not be_empty
    expect(order_book.bids).to_not be_empty
    expect(order_book.asks.first.price).to_not be_nil
    expect(order_book.bids.first.amount).to_not be_nil
    expect(order_book.bids.first.timestamp).to be_nil
    expect(order_book.asks.count).to be > 10
    expect(order_book.bids.count).to be > 10
    expect(order_book.timestamp).to be_nil
    expect(order_book.payload).to_not be nil
  end

  it 'fetch trades' do
    trades = client.trades(eng_eth_pair)
    trade = trades.first

    expect(trade.base).to eq 'ENG'
    expect(trade.target).to eq 'ETH'
    expect(trade.market).to eq 'hotbit'

    expect(trade.amount).to_not be_nil
    expect(trade.price).to_not be_nil
    expect(2000..Date.today.year).to include(Time.at(trade.timestamp).year)
    expect(trade.trade_id).to_not be_nil
    expect(trade.type).to eq("buy").or eq("sell")
  end
end
