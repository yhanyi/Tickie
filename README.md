# Tickie

Compact kdb+/q tickerplant and feed for learning purposes.

## Files

- `tick.q`  - tickerplant
- `rdb.q`   - rdb
- `sym.q`   - schema
- `utils.q` - math utils
- `mock.q`  - automated mock feed
- `feed.q`  - Binance feed

## Usage

We need three terminal instances: tickerplant, rdb, feed. Feel free to run both the mock and Binance feeds together, they populate separate tables.

```bash
q tick.q sym . -p 5010  # Tickerplant.
q rdb.q :5010 -p 5011   # Rdb.
q mock.q                # Mock feed.
q feed.q                # Binance feed.
```

Try running commands in terminal 2 (rdb) to interface with the kdb+ database. Hopefully it works lol.

```q
mocktrade
mockquote
trade
select count i by sym from trade
select avg price by sym from trade
```

To connect from another process/terminal run the following.

```q
h:hopen 5011    / Connect to the rdb on port 5011.
h"count trade"  / Run queries in this format.
```

To exit q, run `exit 0`.

This project scratched my once a year itch to write kdb+/q lmao.
