--====================================================================--
-- Lua Corovel Unit Tests
--
-- Sample code is MIT licensed, the same license which covers Lua itself
-- http://en.wikipedia.org/wiki/MIT_License
-- Copyright (C) 2014-2015 David McCuskey. All Rights Reserved.
--====================================================================--


print( '\n\n##############################################\n\n' )


--====================================================================--
--== Imports


require 'tests.lunatest'


--== setup test suites and run

lunatest.suite( 'tests.lua_corovel_json' )
lunatest.suite( 'tests.lua_corovel_eventloop' )
lunatest.suite( 'tests.lua_corovel_timer' )

lunatest.run()


