--====================================================================--
-- corovel/corona/network.lua
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
-- Corovel : Corona-esque Network Object
--====================================================================--

-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"


--====================================================================--
-- Imports

local http = require 'socket.http'
local https = require 'ssl.https'
local ltn12 = require 'ltn12'
local urllib = require 'socket.url'


local Utils = require 'lua_utils'


--====================================================================--
-- Setup, Constants

http.TIMEOUT = 30 -- this is for raw http


--====================================================================--
-- Support Functions

local function makeHttpRequest( url, method, listener, params )
	print( "makeHttpRequest", url, method )

	local url_parts, hrequest
	local req_params, resp_body = {}, {}
	local event

	url_parts = urllib.parse( url )
	if url_parts.scheme == 'https' then
		hrequest = https.request
	else
		hrequest = http.request
	end

	req_params = {
		url = url,
		method = method,
		source = ltn12.source.string( params.body ),
		headers = params.headers,
		redirect = params.redirect,
		sink = ltn12.sink.table( resp_body )
	}

	local resp_success, resp_code, resp_headers = hrequest( req_params )
	resp_body = table.concat( resp_body )
	-- print( 'http', resp_success, resp_code, resp_headers )
	-- print( 'body', resp_body )

	event = {
		isError=false,
		status=resp_code,
		response=resp_body,
		headers=resp_headers
	}
	if listener then listener( event ) end
end


--====================================================================--
-- System Facade

return {
	request = makeHttpRequest
}
