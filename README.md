# Tickie

Note: WIP, making breaking changes.

Tiny and compact kdb+/q ticker plant with a mock feed for learning purposes.

## Files

- `tick.q`  - tickerplant
- `rdb.q`   - rdb
- `sym.q`   - schema
- `utils.q` - math utils
- `mock.q`  - automated mock feed
- `feed.q`  - Binance feed

## Usage

We need three terminal instances: tickerplant, rdb, feed.

```bash
q tick.q sym . -p 5010  # Terminal 1: tickerplant.
q rdb.q :5010 -p 5011   # Terminal 2: rdb.
q mock.q                # Terminal 3: mock feed.
```

Try running commands in terminal 2 (rdb) to interface with the kdb+ database. Hopefully it works lol.

```q
trade
quote
select count i by sym from trade
select avg price by sym from trade
```

To connect from another process/terminal run the following.

```q
h:hopen 5011    / Connect to the rdb on port 5011.
h"count trade"  / Run queries in this format.
```

To exit q, run `exit 0`.
