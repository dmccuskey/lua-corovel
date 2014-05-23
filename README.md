
## Lua Corovel ##

An event-loop programming environment for Lua.


### Why Corovel ? ###


The name Corovel comes from the phrase "*Coro*na E*ve*nt *L*oop". I created it so that I could run certain modules from my DMC Corona Library in a server environment (eg, async TCP Sockets, WebSockets, and WAMP). I figured if I could create an enviroment similar to the Corona SDK, then I wouldn't have to re-write any of the libraries and could continue to code in my "normal" Corona-esque manner.

The Corona SDK environment provides a rich environment for asynchronous programming via two core objects: the Corona Runtime and Corona Timer. The Runtime sends out events every "frame" and the Timer will call a handler after a certain time has passed. These are important building blocks for async code.


*Corovel is NOT the Corona SDK*

Corovel *does not* provide any visual services to code – eg, sprites, game-engine, etc.



### Features ###

Though it's in its infancy, Corovel is pretty cool. It will allow you to:

* Run unmodified, non-visual code from Corona SDK on a server
  (not all object types have been created)

* create any number of Corvel environments
  Combined with Lua Lanes, each environment can run in its own OS thread. (this already works)



### Dependencies ###

Corovel is a library written in pure Lua. It requires the following Lua modules:

* Lua 5.1 (5.2 should work too, though not tested)
* LuaSocket



### How to Use Corovel ###

Launch your file with Corovel like so:

`lua corovel.lua main.lua`

`lua corovel.lua 'main'`

`lua corovel.lua 'commands.master'`



### Corona Modules ###

These objects from the Corona world have been created:
* Runtime
* timer
* system

These need to be created:
* network
* etc



### Documentation ###

More information coming soon ...
