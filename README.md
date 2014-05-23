Lua Corovel
====================

I created Corovel so that I could run modules from my Corona library in a server environment (eg, async TCP Sockets, Websockets, and WAMP).

The Corona SDK environment provides a rich environment for asynchronous programming via two core objects: the Corona Runtime and Corona Timer. The Runtime sends out events every "frame" and the Timer will call a handler after a certain time has passed. Each of these items can have listeners/callbacks attached to them.

Corovel requires the following Lua modules:

* LuaSocket


More information coming soon ...
