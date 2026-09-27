


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
	tps=100/1000 -- loop sleep, seconds (0.1 = 100 ms); see README, Configuration
}


--== Corona Modules

Config.system = {
	cachesDir=SystemCachesDir,
	documentsDir=SystemDocumentsDir,
	resourceDir=SystemResourceDir,
	temporaryDir=SystemTemporaryDir,
}



return Config
