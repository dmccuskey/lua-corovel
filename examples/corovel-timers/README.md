## Corovel Timers ##

A repeating timer, `enterFrame` events and a clean exit: the command
object sets `is_working` to `false` after two seconds, and Corovel stops.


## Run ##

From this folder, with `COROVEL` set to your lua-corovel checkout:

```sh
LUA_PATH="./?.lua;$COROVEL/?.lua;$COROVEL/corovel/?.lua;;" lua5.1 $COROVEL/corovel.lua main
```

Output (times vary; timers fire on the next loop tick, so a 500 ms timer
lands at about 620 ms):

```
started at	0.35
tick	624
tick	1252
tick	1876
frames seen:	18
```
