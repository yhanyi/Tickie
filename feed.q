.feed.TP_PORT:5010;
.feed.tph:0Ni; / Tickerplant handle.
.feed.symbols:`BTCUSDT`ETHUSDT;
.feed.api:"https://api.binance.com/api/v3/trades";
.feed.interval:1000;
.feed.limit:10;
.feed.lastid:()!();

.feed.connect:{
  .feed.tph:@[hopen;.feed.TP_PORT;{show "Cannot connect to TP on port ",string[.feed.TP_PORT],": ",x; 0Ni}];
  if[not null .feed.tph;
    show "Connected to tickerplant on port ",string .feed.TP_PORT];
  }

.feed.fetch:{[sym]
  / Build url with raze.
  url:raze(.feed.api;"?symbol=";string[sym];"&limit=";string .feed.limit);
  / Curl the api and parse into json.
  raw:raze system raze("curl -s '";url;"'");
  trades:.j.k raw;
  if[not count trades; :(sym;())];
  / Convert to table.
  trades:flip `tradeid`price`size`time`isBuyerMaker`isBestMatch!(
    `long$trades[;`id];
    "F"$trades[;`price];
    "F"$trades[;`qty];
    `timestamp$`long$trades[;`time]*1000000;
    trades[;`isBuyerMaker];
    trades[;`isBestMatch]
    );
  (sym;trades)
  }

.feed.process:{[sym;trades]
  if[not count trades; :()];
  lastid:.feed.lastid[sym];
  if[null lastid;
    .feed.lastid[sym]:exec last tradeid from trades;
    show "Initialised ",string[sym]," at ID: ",string .feed.lastid[sym];
    :()
    ];
  newtrades:select from trades where tradeid > lastid;
  if[count newtrades;
    show "Sending ", string[count newtrades]," ",string[sym]," trades to tickerplant.";
    if[not null .feed.tph;
      i:0;
      while[i<count newtrades;
        neg[.feed.tph](`.u.upd;`trade;(newtrades[i;`time];sym;newtrades[i;`price];newtrades[i;`size];newtrades[i;`tradeid]));
        i+:1;
        ];
      ];
      .feed.lastid[sym]:exec last tradeid from newtrades;
    ]
  }

.feed.fetch_all:{
  .feed.fetchcount+::1;
  results:$[0<system"s";
    / Parallel, '-s' flag passed.
    \ Note:
      Apparently kdb+ slave threads cannot make system calls, like the curl in fetch.
      Parallelise some other way?
    .feed.fetch peach .feed.symbols;
    / Sequential.
    .feed.fetch each .feed.symbols
    ];
  .feed.process ./: results;
  }

.z.ts:{
  if[null .feed.tph; .feed.connect[]]; // Reconnect if disconnected.
  if[not null .feed.tph; .feed.fetch_all[]];
  }

.z.pc:{[h]
  if[h=.feed.tph;show "Disconnected from tickerplant";.feed.tph:0Ni]}

/ Initialise.
.feed.lastid:.feed.symbols!count[.feed.symbols]#0N;
.feed.connect[];
if[not null .feed.tph; .feed.fetch_all[]];
system"t ",string .feed.interval;

show "Binance feeds started. Type 'exit 0' to stop.";
