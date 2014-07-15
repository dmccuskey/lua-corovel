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

local VERSION = "0.2.0"


--====================================================================--
-- Setup, Constants

local tinsert = table.insert
local tremove = table.remove

local Timer = nil -- forward declare


--====================================================================--
-- Support Functions

-- reindex event positions
--
local function reindexArray( array, idx )
	-- print( "reindexArray" )
	for i=idx,#array do
		array[i][6] = i
	end
end

-- run through scheduled events, see if any need run
--
local function checkEventSchedule()
	-- print( "checkEventSchedule" )
	Timer:checkEventSchedule()
end

-- schedule a new event
--
local function performWithDelay( time, handler, iterations )
	-- print("timer.performWithDelay", time, handler, iterations )
	assert( type(time)=='number', "time must be a number value" )
	assert( type(handler)=='function' or type(handler)=='table', "expected event handler" )
	--==--
	if iterations == nil then iterations = 1 end
	if iterations < -1 then iterations = -1 end

	local eternal = false
	if iterations == 0 or iterations == -1 then eternal = true end

	return Timer:scheduleEvent( Timer:createEvent( time, handler, iterations, eternal ) )
end

-- cancel currently scheduled event
--
local function cancelEvent( event )
	-- print("timer.cancelEvent", event )
	assert( type(event)=='table', "expected timer event" )
	--==--
	Timer:removeEventFromSchedule( event )
end 



--====================================================================--
-- Timer Object Class
--====================================================================--


Timer = {}
Timer.NAME = "Timer Object"

Timer.EVENT = 'timer'
Timer.event_schedule = {} -- the scheduled items

--[[
event structure:
e_time - number, delay for each iteration in milliseconds
e_handler - function or object, callback handler
e_iterations - number, number of times to invoke event
e_eternal - boolean, whether it is an eternal running event
e_start - the time when next to run event (system.time + e_time)
e_pos - position (index) in schedule array

we have e_pos so that once we get an event we can quickly figure out
its position so that it can be removed

TODO: think about using a linked list for the event schedule
--]]
function Timer:createEvent( e_time, e_handler, e_iterations, e_eternal )
	-- print( "Timer:createEvent", e_time, e_iterations )
	local e_start, e_pos = 0, 0
	return { e_time, e_handler, e_iterations, e_eternal, e_start, e_pos }
end


function Timer:scheduleEvent( event )
	-- print( "Timer:scheduleEvent" )
	return self:addEventToSchedule( event )
end

function Timer:rescheduleEvent( event )
	return self:addEventToSchedule( self:removeEventFromSchedule( event ) )
end


function Timer:addEventToSchedule( event )
	-- print( "Timer:addEventToSchedule", event[1] )
	-- we keep ordered list of timed events

	local schedule = self.event_schedule

	-- create schedule time
	event[5] = event[1] + system.getTimer()
	-- print( 'add at', event[5] )

	-- insert event into schedule
	local i = 1
	if #schedule > 0 then
		local e_start, end_loop = event[5], #schedule
		repeat
			if e_start < schedule[i][5] then break end
			i = i + 1
		until i > end_loop
	end
	-- print( "inserting event at", i )
	event[6] = i
	tinsert( schedule, i, event )
	reindexArray( schedule, i+1 )
	return event
end

function Timer:removeEventFromSchedule( event )
	-- print( "Timer:removeEventFromSchedule", event[6] )
	--==--
	local schedule = self.event_schedule
	local idx = event[6]
	tremove( schedule, idx )
	reindexArray( schedule, idx )
	return event
end


-- checkEventSchedule()
-- checks scheduled events, handles any which need attention
-- @param time milliseconds since system start
--
function Timer:checkEventSchedule()
	-- print( "Timer:checkEventSchedule", #self.event_schedule )

	if #self.event_schedule == 0 then return end

	local event_schedule = self.event_schedule

	local idx, end_loop = 1, #event_schedule
	local is_done = false

	repeat
		local t = system.getTimer()
		-- print( 'time is ', t, i )
		local evt = event_schedule[idx]
		local e_handler, e_iterate, e_eternal, e_start = evt[2], evt[3], evt[4], evt[5]

		if e_start > t then
			is_done = true

		else
			-- dispatch event
			local event = { time=t }
			if type( e_handler ) == 'function' then
				e_handler( event )
			elseif type( e_handler ) == 'table' then
				local method = e_handler[ self.EVENT ]
				method( e_handler, event )
			end

			-- reschedule/remove event
			if e_eternal then
				self:rescheduleEvent( evt )
			else
				e_iterate = e_iterate - 1
				if e_iterate > 0 then
					evt[3] = e_iterate
					self:rescheduleEvent( evt )
				else
					self:removeEventFromSchedule( evt )
					idx=idx-1; end_loop=end_loop-1 -- adjust for shortened length after remove
				end
			end

		end
		idx = idx + 1

		-- print( 'time end ', i, end_loop, is_done, #event_schedule )
	until is_done or idx > end_loop or #event_schedule == 0

end




--====================================================================--
-- Timer Facade
--====================================================================--


return {
	_Timer = Timer,
	_checkEventSchedule=checkEventSchedule,

	cancel=cancelEvent,
	performWithDelay=performWithDelay
}
