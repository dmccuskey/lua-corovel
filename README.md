
## Lua Corovel ##



### Why Corovel ? ###

I created Corovel so that I could run modules from my Corona library in a server environment (eg, async TCP Sockets, Websockets, and WAMP).

The Corona SDK environment provides a rich environment for asynchronous programming via two core objects: the Corona Runtime and Corona Timer. The Runtime sends out events every "frame" and the Timer will call a handler after a certain time has passed. Each of these items can have listeners/callbacks attached to them.



### Dependencies ###

Corovel is a library written in pure Lua. It requires the following Lua modules:

* Lua 5.1 (5.2 should work too, not tested)
* LuaSocket



### Run Corona Modules ###

Launch your file with Corovel like so:

`lua corovel.lua main.lua`

`lua corovel.lua 'main'`

`lua corovel.lua 'commands.master'`


More information coming soon ...
