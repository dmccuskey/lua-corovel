--====================================================================--
-- Sockets Basic
--
-- Tests the module Lua Sockets
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014-2015 David McCuskey. All Rights Reserved.
--====================================================================--


print("\n===================================================================\n")


--===================================================================--
--== Imports


local Sockets = require 'lua_sockets'


--====================================================================--
--== Setup, Constants


local tconcat = table.concat

local host, port = 'docs.davidmccuskey.com', 80
local sock



--====================================================================--
--== Support Functions


-- make up a generic request for the web server
--
local function sendRequest()

	local bytes, err
	local req_t, req

	local req_t = {
		"GET / HTTP/1.1\r\n",
		"Host: " .. host .. "\r\n",
		"User-Agent: DMC Sockets " .. Sockets.VERSION .. "\r\n",
		"\r\n"
	}
	req = tconcat( req_t, "" )
	bytes, err = sock:send( req )

end


-- our socket callback function
--
local function socketCallback( event )
	print( "socketCallback", event.type )

	local status = event.status

	if event.type == sock.CONNECT then

		if status == sock.CONNECTED then
			print( "=== Socket Connected ===" )
			print( 'socket status:', status )

			sendRequest()

		else
			print( "=== Socket Disconnected ===" )
			print( 'socket status:', status )

			timer.performWithDelay( 2000, function() sock:reconnect() end )
		end


	elseif event.type == sock.READ then
		local len = event.bytes

		print( "=== Data Available ===" )
		print( 'socket status:', status )

		print( 'Before read (buff len):', len )

		-- read our data, using one of several receive types
		repeat
			local data = sock:receive( '*l' )
			print( '>>', data )
		until data == ''

		print( 'After read (buff len):', sock.buffer_size )

	end

end



--====================================================================--
--== Main
--====================================================================--


sock = Sockets:create( Sockets.TCP )
sock:addEventListener( sock.EVENT, socketCallback )
sock:connect( host, port )


