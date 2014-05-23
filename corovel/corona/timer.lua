--====================================================================--
-- corovel/corona/timer.lua
--
--
-- by David McCuskey
-- Documentation: http://docs.davidmccuskey.com/display/docs/Lua+Corovel
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
-- Corovel : Corona-esque Timer Object
--====================================================================--

-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"


--====================================================================--
-- Setup, Constants

local Timer = nil -- forward declare


--====================================================================--
-- Support Functions

-- checkEventSchedule(), static function
--
local function checkEventSchedule(  )
	-- print( "checkEventSchedule" )
	Timer:checkEventSchedule()
end

-- performWithDelay(), static function
--
local function performWithDelay( time, handler, iterations )
	-- print("timer.performWithDelay", time, handler, iterations )
	if iterations == nil then iterations = 1 end
	if iterations < -1 then iterations = -1 end
	--==--

	local eternal = false
	if iterations == 0 or iterations == -1 then eternal = true end

	Timer:scheduleEvent( Timer:createEvent( time, handler, iterations, eternal ) )
end



--====================================================================--
-- Timer Object Class
--====================================================================--

Timer = {}
Timer.NAME = "Timer Object Class"

Timer.EVENT = 'timer'
Timer.event_schedule = {} -- the scheduled items


function Timer:createEvent( e_time, e_handler, e_iterations, e_eternal )
	-- print( "Timer:createEvent", e_time, e_iterations )
	local e_start, e_pos = 0, 0
	return { e_time, e_handler, e_iterations, e_eternal, e_start, e_pos }
end


function Timer:scheduleEvent( event )
	-- print( "Timer:scheduleEvent" )
	self:addEventToSchedule( event )
end

function Timer:rescheduleEvent( event )
	self:addEventToSchedule( self:removeEventFromSchedule( event ) )
end


function Timer:addEventToSchedule( event )
	-- print( "Timer:addEventToSchedule", event[1] )
	-- we keep ordered list of timed events

	local schedule = self.event_schedule
	local i, end_loop = 1, #schedule

	event[5] = event[1] + system.getTimer()
	local e_start = event[5]
	-- print( 'add at', e_start )

	if end_loop == 0 then
		event[6] = 1
		table.insert( schedule, event )
		return
	end

	repeat
		if e_start < schedule[i][5] then break end
		i = i + 1
	until i > end_loop

	-- print("inserting at ", i )
	event[6] = i
	table.insert( schedule, i, event )

	-- reindex event positions
	while i+1 <= #schedule do
		schedule[i+1][6] = i+1
		i = i + 1
	end

end

function Timer:removeEventFromSchedule( event )
	-- print( "Timer:removeEventFromSchedule", event[6] )
	local schedule = self.event_schedule
	local idx = event[6]
	local evt = table.remove( schedule, idx )

	-- reindex event positions
	while idx <= #schedule do
		schedule[idx][6] = idx
		idx = idx + 1
	end

	return evt
end


-- checkEventSchedule()
-- checks scheduled events, handles any which need attention
--
function Timer:checkEventSchedule()
	-- print( "Timer:checkEventSchedule", #self.event_schedule )

	if #self.event_schedule == 0 then return end

	local event_schedule = self.event_schedule

	local i, end_loop = 1, #event_schedule
	local is_done = false

	repeat
		local t = system.getTimer()
		-- print( 'time is ', t, i )
		local evt = event_schedule[i]
		local e_handler, e_iterate, e_eternal, e_start = evt[2], evt[3], evt[4], evt[5]

		if e_start > t then
			is_done = true

		else
			local event = { time=t }

			if type( e_handler ) == 'function' then
				e_handler( event )

			elseif type( e_handler ) == 'table' then
				local method = e_handler[ self.EVENT ]
				method( e_handler, event )

			else
				print( "WARNING: Timer handler error" )

			end

			if not e_eternal then
				e_iterate = e_iterate - 1

				if e_iterate > 0 then
					evt[3] = e_iterate
					self:rescheduleEvent( evt )

				else
					self:removeEventFromSchedule( evt )
					i=i-1; end_loop=end_loop-1 -- adjust for shortened length after remove

				end
			end

		end

		i = i + 1

		-- print( 'time end ', i, end_loop, is_done, #event_schedule )
	until is_done or i > end_loop or #event_schedule == 0

end




--====================================================================--
-- Timer Facade
--====================================================================--


return {
	_checkEventSchedule = checkEventSchedule,
	performWithDelay=performWithDelay
}
