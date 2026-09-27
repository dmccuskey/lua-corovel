# Development

## Tests

Two sets, both need Lua 5.1 with LuaSocket, LuaFileSystem, LuaSec and dkjson or cjson (see the [Quick Start](../README.md#quick-start)).

**Lunatest**, run inside Corovel (event loop, timers, the `json` shim): `tests/`, loaded by the root `main.lua`.

```sh
./run.sh                           # uses lua5.1
LUA=/path/to/lua ./run.sh          # another Lua 5.1 interpreter
```

It prints `5 passed, 0 failed` and then keeps running, since `main.lua` returns nothing (see [Running a Module](reference.md#running-a-module)): stop it with Ctrl-C.

**Busted**, run outside Corovel (the timer schedule, with `system` mocked): `spec/`. Needs [busted](https://lunarmodules.github.io/busted/) (`luarocks install busted`).

```sh
busted spec
```

It prints `2 successes / 0 failures`.

## Where It's Used

dmc-websockets' [Autobahn harness](https://github.com/dmccuskey/dmc-websockets/tree/master/tests/autobahn) runs the WebSocket client under Corovel against the Autobahn test suite; a change here should keep that run's results the same. Its `run.sh` shows a full `LUA_PATH` and a stub for `ssl.https` when LuaSec isn't installed.
