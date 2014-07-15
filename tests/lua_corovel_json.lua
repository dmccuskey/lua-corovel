module(..., package.seeall)


--====================================================================--
-- Test: Json module
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"


--====================================================================--
-- Testing Setup
--====================================================================--

local json

function suite_setup()
	json = require 'json'
end


function test_jsonModule()
	assert_not_nil( json, "json module required" )
end
