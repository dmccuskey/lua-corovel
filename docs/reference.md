# Reference

How Corovel runs a module, its settings, and what each Solar2D API it provides does, including where it differs from Solar2D. Checked against the code in 2026 (version 0.1.0).

## Running a Module

```sh
lua5.1 corovel.lua <module>
```

`<module>` is a name in `require` form: `main` loads `main.lua`, `commands.master` loads `commands/master.lua`, searched on `LUA_PATH`. `corovel.lua` loads its own modules from `corovel/`, so that folder must be on `LUA_PATH` too:

```sh
LUA_PATH="./?.lua;/path/to/lua-corovel/?.lua;/path/to/lua-corovel/corovel/?.lua;;" \
  lua5.1 /path/to/lua-corovel/corovel.lua main
```

At start, Corovel:

1. Loads `corovel_cfg.lua`, if found (see [Configuration](#configuration)).
2. Sets the globals `Runtime`, `timer`, `system`, `network` and `crypto`, and `__corovel` (the configuration).
3. Starts a repeating timer that sends `enterFrame` events.
4. Loads `<module>` and looks at what it returns:
   - nothing (`require` returns `true`): Corovel runs forever, like a server.
   - a table with `new()`: Corovel calls `Module:new()` and uses the result as below.
   - a table: Corovel calls its `execute()` method once, if it has one, then runs while its `is_working` field is true. A table without `is_working` stops right after `execute()`.
5. Loops: fires the timers that are due, then sleeps `tps` seconds, until the module is done.

## Configuration

Settings live in `corovel_cfg.lua`, a Lua file that returns a table. Corovel loads it with `require`, so it takes the first one on `LUA_PATH`: with `./?.lua` first, a project's own file wins over the one in the lua-corovel checkout. Without one, every setting has its default.

```lua
local Config = {}

Config.corovel = {
	tps=0.1   -- loop sleep in seconds: about 10 frames per second
}

Config.system = {
	documentsDir='/var/lib/myapp',   -- others default to the current directory
}

return Config
```

| key | type | default | effect |
|---|---|---|---|
| `corovel.tps` | number | `0.1` | How long the loop sleeps between turns, in seconds. The `enterFrame` timer uses the same number as its delay in milliseconds, so in practice it fires once per turn: `0.1` gives about 10 frames per second, `0.001` (what the dmc-websockets Autobahn harness uses) as fast as the code allows. It also sets timer resolution: a timer fires on the first turn after it's due. Despite the name, it isn't ticks per second. |
| `system.cachesDir` | string | current directory | `system.CachesDirectory` |
| `system.documentsDir` | string | current directory | `system.DocumentsDirectory` |
| `system.resourceDir` | string | current directory | `system.ResourceDirectory`, and the default for `system.pathForFile()` |
| `system.temporaryDir` | string | current directory | `system.TemporaryDirectory` |

"Current directory" is the directory Corovel was started from. The table is also available to your code as the global `__corovel`, so a project can keep its own settings in it.

Corovel doesn't read `dmc_corona.cfg`; libraries that use it load it themselves through [dmc-corona-boot](https://github.com/dmccuskey/dmc-corona-boot).

## Runtime

- `Runtime:addEventListener( name, listener )`: `listener` is a function, called with the event, or a table, whose method named after the event is called (`listener:enterFrame( event )`). Adding the same listener twice prints a warning.
- `Runtime:removeEventListener( name, listener )`
- `Runtime:dispatchEvent( event )`: calls every listener for `event.name`, in no particular order.

Corovel itself sends only `enterFrame`, with `event.name` and `event.time` (milliseconds since start). Other names work for your own events.

## timer

- `timer.performWithDelay( delay, listener, iterations )`: calls `listener` after `delay` milliseconds, `iterations` times (default 1; `0` or `-1` repeats forever). `listener` is a function or a table with a `timer` method. The event has only `time`. Returns a handle for `timer.cancel()`.
- `timer.cancel( handle )`

Differences from Solar2D: the event has no `source` or `count`; each repeat is scheduled from when the last one fired, so repeating timers drift by up to one loop turn each time; there is no `timer.pause()` or `timer.resume()`.

## system

- `system.getTimer()`: milliseconds since Corovel started.
- `system.pathForFile( file, baseDir )`: `baseDir .. "/" .. file`; `baseDir` defaults to `system.ResourceDirectory`.
- `system.CachesDirectory`, `system.DocumentsDirectory`, `system.ResourceDirectory`, `system.TemporaryDirectory`: plain path strings, set in [Configuration](#configuration).

Nothing else from Solar2D's `system` (no `getInfo()`, `openURL()`, events).

## network

`network.request( url, method, listener, params )` makes an HTTP or HTTPS request (LuaSocket, LuaSec) and calls `listener` once with:

| field | value |
|---|---|
| `isError` | `true` if the request failed |
| `status` | the HTTP status code; on failure, LuaSocket's error message (e.g. `"closed"`) |
| `phase` | always `"ended"` |
| `response` | the body, as a string |
| `headers` | the response headers |

- `method`: `GET` (default), `POST`, `HEAD`, `PUT` or `DELETE`.
- `params`: `headers`, `body` (a string), `redirect` (LuaSocket's option; Solar2D's `handleRedirects` is ignored), `bodyType` (`"text"` or `"binary"`, checked but not used). `timeout` is ignored: every request has LuaSocket's 30-second timeout.

Unlike Solar2D, the request **blocks**: the loop, and every timer, waits until it's done, and `listener` is called before `network.request()` returns. It prints a line for each request. There's no `network.download()`, no progress events, no request id and no `network.cancel()`.

## json

`require 'json'` returns the first JSON library installed: `dkjson` or `cjson`. As in Solar2D, `json` is a module, not a global. Corovel installs none itself; see [Known Issues](#known-issues) for what happens without one.

## crypto

The global `crypto` has `crypto.hmac( algorithm, data, key )` and the constant `crypto.sha256`, from the LuaCrypto module (`require 'crypto'`), which you install yourself. Nothing else from Solar2D's `crypto` (no `digest()`, no other constants).

## plugin.openssl

`require 'plugin.openssl'` loads LuaSec and registers it under `plugin_luasec_ssl`, the name Solar2D's OpenSSL plugin uses. dmc-sockets loads it for `wss://` connections.

## Known Issues

- **Crash when a timer callback cancels another timer**: `attempt to index local 'evt'` in `timer.lua`. The loop in `Timer:checkEventSchedule()` keeps the schedule's old length. Seen after dmc-wamp examples call `leave()`.
- **LuaSec is required at start**: `corona/network.lua` loads `ssl.https` even if nothing uses `network`. The dmc-websockets Autobahn harness works around it by preloading a stub.
- **`json` without dkjson or cjson**: `json.lua` falls back to `require 'json'`, which finds itself, so `require 'json'` returns an error message (a string) instead of a module, and the first call on it fails.
- **`Runtime:removeEventListener()` for an event with no listeners** prints a warning and then fails (`attempt to index local 'listeners'`); in Solar2D it's harmless.
- **`Runtime:addEventListener( name, nil )`** fails with `attempt to index global 'Utils'` instead of its own error message. `runtime.lua` also defines `createEventListenerKey` as a global.
- **`crypto` without LuaCrypto**: `crypto.hmac()` fails with an index error rather than saying LuaCrypto is missing. LuaCrypto is unmaintained, so WAMP-CRA authentication in dmc-wamp can't be tested headless.
- **The TCP examples don't run**: `examples/corovel-simple-tcp` and `corovel-simple-async-tcp` require module names from 2015 and connect to a host that's gone (see their READMEs).
