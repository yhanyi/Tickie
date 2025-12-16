.feed.valid:`HRT`JS`OPT`CIT`JTG;
.feed.TP_PORT:5010;
.feed.tph:0Ni;
.feed.times:.z.n;
maxChunkSize:50;
n:1000;

.feed.mocktrade:(n?.feed.times;n?.feed.valid;n?n;n?`float$n);
.feed.mockquote:(n?.feed.times;n?.feed.valid;n?`float$n;n?`float$n;n?n;n?n);

.z.ts:{
  if[null .feed.tph;
    .feed.tph:@[hopen;.feed.TP_PORT;0Ni]];
  if[not null .feed.tph;
    t:rand`mocktrade`mockquote;
    neg[.feed.tph](`.u.upd;t;flip(1+rand maxChunkSize)?flip .feed t)];
  }

.z.pc:{[h]if[h=.feed.tph;.feed.tph:0Ni]}

\t 5000
