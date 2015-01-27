--====================================================================--
-- corovel/corona/network.lua
--
-- Documentation: http://docs.davidmccuskey.com/
--====================================================================--

--[[

The MIT License (MIT)

Copyright (c) 2014-2015 David McCuskey

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
--== Corovel : Corona-esque Network Object
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local http = require 'socket.http'
local https = require 'ssl.https'
local ltn12 = require 'ltn12'
local urllib = require 'socket.url'

local Utils = require 'lua_utils'



--====================================================================--
--== Setup, Constants


local DEFAULT_METHOD = 'GET'
local DEFAULT_TYPE = 'text'
local DEFAULT_TIMEOUT = 30 -- this is for raw http, default


local tconcat = table.concat

http.TIMEOUT = 30 -- this is for raw http



--====================================================================--
--== Support Functions


local function makeHttpRequest( url, method, listener, params )
	-- print( "Network.makeHttpRequest", url, method )
	method = method or DEFAULT_METHOD
	params = params or {}
	-- params.headers = params.headers
	-- params.body = params.body
	params.bodyType = params.bodyType or DEFAULT_TYPE
	-- params.progress = params.progress
	-- params.response = params.response
	params.timeout = params.timeout or DEFAULT_TIMEOUT
	-- params.handleRedirects = params.handleRedirects

	assert( url )
	assert( method and Utils.propertyIn( { 'GET', 'POST', 'HEAD', 'PUT', 'DELETE' }, method ) )
	assert( listener )
	assert( params.progress==nil or Utils.propertyIn( { 'upload', 'download' }, params.progress ) )
	assert( Utils.propertyIn( { 'text', 'binary' }, params.bodyType ) )
	--==--

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

	--[[
	print( 'http:', resp_success, resp_code, resp_headers )
	on success:
	http:	1	200	<table>
	on error:
	http:	nil	closed	nil
	--]]

	event = {
		isError=(resp_success==nil),
		status=resp_code,
		phase='ended',
		response=tconcat( resp_body ),
		headers=resp_headers
	}

	if listener then listener( event ) end
end




--====================================================================--
--== Network Facade
--====================================================================--


return {
	request = makeHttpRequest
}
