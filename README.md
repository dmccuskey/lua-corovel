
## Lua Corovel ##

An event-loop programming environment for Lua.


### Why Corovel ? ###


The name Corovel comes from the phrase *Corona Event Loop*. I created it so that I could run certain modules from my DMC Corona Library in a server environment (eg, async TCP Sockets, WebSockets, and WAMP). I figured if I could create an enviroment similar to the Corona SDK, then I wouldn't have to re-write any of the libraries and could continue to code in my "normal" Corona-esque manner. =)

Async programming is easy if you have the right building blocks for async code. The Corona SDK environment provides two core objects: the Corona Runtime and Corona Timer. The event loop powers both the *Runtime* which sends out events every "frame" and the *Timer* which will call a handler after a certain time has passed. 


*Corovel is NOT the Corona SDK*

Corovel *does not* provide any visual services to code – eg, sprites, game-engine, etc.



### Features ###

Though it's in its infancy, Corovel is pretty cool. It will allow you to:

* Run unmodified, *non-visual* code from Corona SDK on a server

* create other Corvel environments in separate threads
  Combined with Lua Lanes, each environment can run in its own OS thread.


### Overview ###

![Corovel Cool](https://raw.githubusercontent.com/dmccuskey/lua-corovel/master/assets/corovel-main.png "Corovel Overview")


![Corovel Cool](https://raw.githubusercontent.com/dmccuskey/lua-corovel/master/assets/corovel-sub.png "Corovel Threads")


### Dependencies ###

Corovel is a library written in pure Lua. It requires the following Lua modules:

* Lua 5.1 (5.2 should work too, though not tested)
* LuaSocket



### How to Use Corovel ###

Launch your file with Corovel like so:

* `lua corovel.lua main`
  This launches `main.lua` inside of the main Corovel

* `lua corovel.lua commands.master`
  This launches the file `commands/master.lua` inside of the main Corovel



### Corona Modules ###

These objects from the Corona world are available, but might not be complete:
* Runtime
* timer
* system
* network



### Documentation ###

More information coming soon ...
