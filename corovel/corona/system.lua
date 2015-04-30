--====================================================================--
-- corovel/corona/system.lua
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
--== Corovel : Corona-esque System Object
--====================================================================--


-- Semantic Versioning Specification: http://semver.org/

local VERSION = "0.1.0"



--====================================================================--
--== Imports


local socket = require 'socket'
local lfs = require 'lfs'



--====================================================================--
--== Setup, Constants


local Config = _G.__corovel
local CWD = lfs.currentdir()
local start_time = socket.gettime()

local CACHES_DIR = Config.system.cachesDir or CWD
local DOCUMENTS_DIR = Config.system.documentsDir or CWD
local RESOURCE_DIR = Config.system.resourceDir or CWD
local TEMPORARY_DIR = Config.system.temporaryDir or CWD



--====================================================================--
--== Support Functions


local function millisecondsSinceStart()
	return ( socket.gettime() - start_time ) * 1000
end


-- @TODO: get system separator
local function systemPathForFilename( file, baseDir )
	if baseDir==nil then baseDir=RESOURCE_DIR end
	return baseDir .. '/' .. file
end



--====================================================================--
--== System Facade
--====================================================================--


return {
	getTimer=millisecondsSinceStart,
	pathForFile=systemPathForFilename,

	CachesDirectory=CACHES_DIR,
	DocumentsDirectory=DOCUMENTS_DIR,
	ResourceDirectory=RESOURCE_DIR,
	TemporaryDirectory=TEMPORARY_DIR,
}
