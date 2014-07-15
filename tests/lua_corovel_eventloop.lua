module(..., package.seeall)


--====================================================================--
-- Test: Corovel Eventloop module
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"


--====================================================================--
-- Testing Setup
--====================================================================--

local EventLoop

function suite_setup()
	EventLoop = require 'event_loop'
end


function test_eventLoopModule()
	assert_not_nil( EventLoop, "Corovel EventLoop module not found" )
end

function test_eventLoopModule_errors()
	assert_error( function() EventLoop.createEventLoop( { lua_module=nil } ) end, "expected error from event loop" )
end
