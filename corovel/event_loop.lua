--====================================================================--
-- corovel/event_loop.lua
--
-- generates an event-loop, Corona SDK-style
--
-- Documentation: http://docs.davidmccuskey.com/display/docs/Lua+Corovel
--====================================================================--

--[[

The MIT License (MIT)

Copyright (c) 2014-2015 David McCuskey

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

--]]



--====================================================================--
--== Corovel : Event Loop
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Setup, Constants


local assert = assert
local type = type

-- Ticks per Second
local DEFAULT_TPS = 100/1000 -- 100 ms



--====================================================================--
--== Main Function


-- eventLoopGenerator()
-- @params params table of options
-- * lua_module string path/name of module to load
-- * tps number approximate "ticks per second" to process
--
local function eventLoopGenerator( params )
	-- print( "eventLoopGenerator", params.cmd_module )
	assert( type(params.cmd_module)=='string', 'Corovel missing string module name' )
	--==--

	--== Imports

	-- process Corovel config before other System items are imported
	local OK, CorovelCfg = pcall( function() return require( 'corovel_cfg' ) end )
	if not OK then
		CorovelCfg = {}
	end
	if not CorovelCfg.corovel then CorovelCfg.corovel={} end
	if not CorovelCfg.system then CorovelCfg.system={} end

	-- Globals, these are set in Lua environment
	_G.__corovel = CorovelCfg
	_G.crypto = require 'luacrypto'
	_G.network = require 'corona.network'
	_G.Runtime = require 'corona.runtime'
	_G.system = require 'corona.system'
	_G.timer = require 'corona.timer'

	-- Local scope
	local Command = require( params.cmd_module )
	local socket = require 'socket'

	--== Setup, Constants

	local tps = CorovelCfg.corovel.tps or DEFAULT_TPS
	local cmd

	-- use timer to perform Runtime actions
	_G.timer.performWithDelay( tps, _G.Runtime, -1 )

	--== Processing

	if type(Command)=='boolean' then
		-- no returned object from Lua file
		cmd = Command

	else
		if Command.new then
			cmd = Command:new( params.cmd_params )
		else
			cmd = Command
		end
		if cmd.execute then cmd:execute( params.cmd_params ) end
	end

	--== Loop until done

	local checkEventSchedule = timer._checkEventSchedule
	local ssleep = socket.sleep
	local timer = _G.timer
	while cmd==true or cmd.is_working do
		-- print( "Checking Command Event Runtime" )
		checkEventSchedule( timer )
		ssleep( tps )
	end

end



return {
	createEventLoop=eventLoopGenerator
}
