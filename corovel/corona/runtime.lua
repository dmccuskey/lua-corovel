--====================================================================--
-- corovel/corona/runtime.lua
--
--
-- by David McCuskey
-- Documentation: http://docs.davidmccuskey.com/display/docs/lua-corovel
--====================================================================--

--[[

The MIT License (MIT)

Copyright (c) 2014 David McCuskey

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
-- Corovel : Corona-esque Runtime Object
--====================================================================--

-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"


--====================================================================--
--== Support Functions


-- callback is either function or object (table)
function createEventListenerKey( e_name, callback )
	return e_name .. "::" .. tostring( callback )
end



--====================================================================--
-- Runtime Class
--====================================================================--

local Runtime = {}
Runtime.NAME = "Runtime Class"

Runtime._event_listeners = {}

Runtime.ENTERFRAME_EVENT = 'enterFrame'


--====================================================================--
--== Public Methods


-- addEventListener()
--
function Runtime:addEventListener( e_name, listener )
	-- print( "Runtime:addEventListener", e_name, listener );

	-- Sanity Check

	if not e_name or type(e_name)~='string' then
		error( "ERROR addEventListener: event name must be string", 2 )
	end
	if not listener and not Utils.propertyIn( {'function','table'}, type(listener) ) then
		error( "ERROR addEventListener: listener must be a function or object", 2 )
	end

	-- Processing

	local events, listeners, key

	events = self._event_listeners
	if not events[ e_name ] then events[ e_name ] = {} end
	listeners = events[ e_name ]

	key = createEventListenerKey( e_name, listener )
	if listeners[ key ] then
		print("WARNING:: Runtime:addEventListener, already have listener")
	else
		listeners[ key ] = listener
	end

end


-- removeEventListener()
--
function Runtime:removeEventListener( e_name, listener )
	-- print( "Runtime:removeEventListener" );

	local listeners, key

	listeners = self._event_listeners[ e_name ]
	if not listeners or type(listeners)~= 'table' then
		print("WARNING:: Runtime:removeEventListener, no listeners found")
	end

	key = createEventListenerKey( e_name, listener )

	if not listeners[ key ] then
		print("WARNING:: Runtime:removeEventListener, listener not found")
	else
		listeners[ key ] = nil
	end

end


function Runtime:dispatchEvent( event )
	-- print( "Runtime:dispatchEvent", event.name );
	local e_name, listeners

	e_name = event.name
	if not e_name or not self._event_listeners[ e_name ] then return end

	listeners = self._event_listeners[ e_name ]
	if type(listeners)~='table' then return end

	for k, callback in pairs( listeners ) do

		if type( callback) == 'function' then
		 	callback( event )

		elseif type( callback )=='table' and callback[e_name] then
			local method = callback[e_name]
			method( callback, event )

		else
			print( "WARNING: Runtime dispatchEvent", e_name )

		end
	end
end


--====================================================================--
--== Private Methods

-- none


--====================================================================--
--== Event Handlers

-- timer()
-- callback from timer loop
--
function Runtime:timer( event )
	-- print( "Runtime:timer" )
	local evt = { name=Runtime.ENTERFRAME_EVENT, time=event.time }
	self:dispatchEvent( evt )
end




return Runtime
