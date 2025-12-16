/ Load schema from root directory.
system"l ",(src:first .z.x,enlist"sym"),".q"

if[not system"p";system"p 5010"]

/ Load utils from root directory.
\l utils.q

\d .u

/ Opens/creates log file.
ld:{
  logpath:(-10_string L),string x;
  / Create only parent directory "sym/", remove leading : and date filename.
  dirpath:1_(-10_logpath);
  @[system;"mkdir -p \"",dirpath,"\"";{}];
  if[not type key L::`$logpath;.[L;();:;()]];
  i::j::-11!(-2;L);
  if[0<=type i;
    -2 (string L)," is a corrupt log. Truncate to length ",(string last i)," and restart";
    exit 1];
  hopen L
  };

/ Initialise tickerplant.
tick:{
  init[];
  if[not min(`time`sym~2#key flip value@)each t;'`timesym];
  @[;`sym;`g#]each t;
  d::.z.D;
  if[l::count y;
    L::`$":",y,"/",x,"/",string d;
    show L;
    l::ld d]
  };

endofday:{end d;d+:1;if[l;hclose l;l::0(`.u.ld;d)]};
ts:{if[d<x;if[d<x-1;system"t 0";'"more than one day?"];endofday[]]};

if[system"t";
 .z.ts:{pub'[t;value each t];@[`.;t;@[;`sym;`g#]0#];i::j;ts .z.D};
 upd:{[t;x]
 if[not -16=type first first x;if[d<"d"$a:.z.P;.z.ts[]];a:"n"$a;x:$[0>type first x;a,x;(enlist(count first x)#a),x]];
 t insert x;if[l;l enlist (`upd;t;x);j+:1];}];

if[not system"t";system"t 1000";
 .z.ts:{ts .z.D};
 upd:{[t;x]ts"d"$a:.z.P;
 if[not -16=type first first x;a:"n"$a;x:$[0>type first x;a,x;(enlist(count first x)#a),x]];
 f:key flip value t;pub[t;$[0>type first x;enlist f!x;flip f!x]];if[l;l enlist (`upd;t;x);i+:1];}];

\d .
.u.tick[src;.z.x 1];

\
 Globals used
 .u.w - dictionary of tables -> (handle;syms)
 .u.i - msg count in log file
 .u.j - total msg count (log file plus those held in buffer)
 .u.t - table names
 .u.L - tp log filename
 .u.l - handle to tp log file
 .u.d - date
