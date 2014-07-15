module(..., package.seeall)


--====================================================================--
-- Test: Corovel Timer module
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"


--====================================================================--
-- Testing Setup
--====================================================================--

local Timer

function suite_setup()
	Timer = require 'corona.timer'
end


function test_timerModule()
	assert_not_nil( Timer, "Corovel Timer module not found" )
end

function test_timerModule_errors()
	assert_error( function() Timer.performWithDelay( nil, nil ) end, "expected error from timer" )
	assert_error( function() Timer.performWithDelay( "200", nil ) end, "expected error from timer" )
	assert_error( function() Timer.performWithDelay( 200, nil ) end, "expected error from timer" )
	assert_error( function() Timer.performWithDelay( 200, "string" ) end, "expected error from timer" )
end
