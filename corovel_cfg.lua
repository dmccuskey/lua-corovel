


--====================================================================--
--== Setup, Constants


-- These can be set, otherwise they default to Current Working Directory

-- Caches Directory
local SystemCachesDir = nil

-- Documents Directory
local SystemDocumentsDir = nil

-- Resource Directory
local SystemResourceDir = nil

-- Temporary Directory
local SystemTemporaryDir = nil



--====================================================================--
--== Config Exports
--====================================================================--


local Config = {}


--== Corovel

Config.corovel = {
	tps=100/1000 -- 100ms
}


--== Corona Modules

Config.system = {
	cachesDir=SystemCachesDir,
	documentsDir=SystemDocumentsDir,
	resourceDir=SystemResourceDir,
	temporaryDir=SystemTemporaryDir,
}


--== WAMP

Config.wamp = {
	host='ws://192.168.3.84',
	port=8080,
	realm='realm1'
}



return Config
