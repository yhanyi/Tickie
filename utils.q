\d .u

/ Initialise subscriber dictionary.
init:{w::t!(count t::tables`.)#()}

/ Delete subscriber.
del:{w[x]_:w[x;;0]?y};

/ Handle port closure (subscriber disconnect).
.z.pc:{del[;x]each t};

/ Select rows based on symbol filter.
sel:{$[`~y;x;select from x where sym in y]}

/ Publish to subscribers.
pub:{[t;x]
  {[t;x;w]
    if[count x:sel[x]w 1;
      (neg first w)(`upd;t;x)
      ]
    }[t;x]each w t
  }

/ Add subscriber.
add:{
  $[(count w x)>i:w[x;;0]?.z.w;
    / Subscriber already exists, update filter.
    .[`.u.w;(x;i;1);union;y];
    / New subscriber.
    w[x],:enlist(.z.w;y)];
  (x;$[99=type v:value x;sel[v]y;@[0#v;`sym;`g#]])
  }

/ Subscribe function.
sub:{
  / Subscribe to all tables.
  if[x~`;:sub[;y]each t];
  / Validate table exists.
  if[not x in t;'x];
  / Remove existing subscription.
  del[x].z.w;
  / Add new subscription.
  add[x;y]
  }

/ End of day notification.
end:{(neg union/[w[;;0]])@\:(`.u.end;x)}

\d .
