package.path = './corovel/?.lua;' .. package.path


describe( "Module Test: corona.timer", function()

	describe( "Test: Timer Basics", function()

		local Timer

		setup( function()
			Timer = require 'corona.timer'

			-- mock system.*
			-- TODO: make this more of a mock object
			_G.system = {
				getTimer = function()
					return 222.22
				end
			}
		end)


		it( "returns a facade", function()
			assert.is.equal( type(Timer), 'table' )
			assert.is.equal( type(Timer.performWithDelay), 'function' )
		end)

		it( "schedules events in order", function()
			local e1, e2, e3

			e1 = Timer.performWithDelay( 1000, function() print("one") end)
			assert.is.equal( #Timer._Timer.event_schedule, 1 )
			assert.is.equal( e1[6], 1 )

			e2 = Timer.performWithDelay( 2000, function() print("two") end)
			assert.is.equal( e1[6], 1 )
			assert.is.equal( e2[6], 2 )

			e3 = Timer.performWithDelay( 500, function() print("three") end)
			assert.is.equal( #Timer._Timer.event_schedule, 3 )
			assert.is.equal( e1[6], 2 )
			assert.is.equal( e2[6], 3 )
			assert.is.equal( e3[6], 1 )

			Timer.cancel( e1 )
			assert.is.equal( #Timer._Timer.event_schedule, 2 )
			assert.is.equal( e2[6], 2 )
			assert.is.equal( e3[6], 1 )
			
		end)


	end) -- Test: XMLList

end) -- lua_e4x.lua

