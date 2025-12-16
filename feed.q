api:"https://api.binance.com/api/v3/trades?symbol=BTCUSDT&limit=3";

raw:raze system raze("curl -s '";api;"'")
json:.j.k raw

show json;
