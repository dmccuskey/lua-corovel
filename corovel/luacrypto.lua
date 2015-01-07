-- create Corona-esque crypto interface



local has_crypto, crypto = pcall( require, 'crypto' )


local __crypto = crypto
local ICrypto = {}

package.loaded["crypto"] = ICrypto

ICrypto.__crypto = __crypto  -- original crypto


--== Constants

ICrypto.sha256 = 'sha256'


--== Functions

function ICrypto.hmac( ... )
	return __crypto.hmac.digest( ... )
end


return ICrypto
