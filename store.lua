local cjson = require "cjson"
local resty_redis = require "resty.redis"

local redis = resty_redis:new()
redis:set_timeout(1000)  -- 1 sec

local ok, err = redis:connect("127.0.0.1", 6379)
if not ok then
ngx.log(ngx.ERR, err)
return
end

redis:select(15)

-- TODO: Never accept until spendingj 1 hour in using cookie.

local params = {
  time = ngx.now(),
  method = ngx.req.get_method(),

  remote_addr = ngx.var.remote_addr,
  http_x_forwarded_for = ngx.var.http_x_forwarded_for,

  scheme = ngx.var.scheme,
  http_host = ngx.var.http_host,
  request_uri = ngx.var.request_uri,
  args = ngx.var.args,

  url = ngx.var.scheme .. "://" .. ngx.var.http_host .. ngx.var.request_uri,
}

for k, v in pairs(ngx.req.get_headers()) do
  params[k] = v
end

redis:rpush("inlog", cjson.encode(params))
-- ngx.say(cjson.encode(params))
