--====================================================================--
-- Corovel Timers
--
-- Timers and enterFrame events under Corovel, then a clean exit
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014-2015 David McCuskey. All Rights Reserved.
--====================================================================--


local App = { is_working = true }

local frames = 0
local function onEnterFrame( event )
	frames = frames + 1
end

function App:execute()
	print( "started at", system.getTimer() )
	Runtime:addEventListener( 'enterFrame', onEnterFrame )
	timer.performWithDelay( 500, function( event )
		print( "tick", math.floor( event.time ) )
	end, 3 )
	timer.performWithDelay( 2000, function()
		Runtime:removeEventListener( 'enterFrame', onEnterFrame )
		print( "frames seen:", frames )
		App.is_working = false  -- corovel exits when this is false
	end )
end

return App
