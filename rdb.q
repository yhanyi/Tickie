if[not "w"=first string .z.o;system "sleep 1"];

upd:insert;

/ Get tickerplant and history ports. Default to 5010,5012.
.u.x:.z.x,(count .z.x)_(":5010";":5012");

/ End of day: save, clear, hdb reload.
.u.end:{t:tables`.;t@:where `g=attr each t@\:`sym;.Q.hdpf[`$":",.u.x 1;`:.;x;`sym];@[;`sym;`g#] each t;};

/ Init schema and sync up from log file. cd to hdb (so client save can run).
.u.rep:{(.[;();:;].)each x;if[null first y;:()];-11!y;system "cd ",1_-10_string first reverse y};

/ Connect to tickerplant for (schema;(logcount;log)).
.u.rep .(hopen `$":",.u.x 0)"(.u.sub[`;`];`.u `i`L)";
