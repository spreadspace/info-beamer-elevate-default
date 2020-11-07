util.init_hosted()

-- this is only supported on the Raspi....
--util.noglobals()

node.set_flag("no_clear")

gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local font = CONFIG.font
local logo = CONFIG.logo:ensure_loaded()
local title = CONFIG.title
local line = resource.create_colored_texture(1,1,1,0.5)
local serial = sys.get_env("SERIAL") or "<no serial>"

local colors = {
   black  = { 0.0, 0.0, 0.0, 1.0},
   white  = { 1.0, 1.0, 1.0, 1.0},
   grey   = { 0.5, 0.5, 0.5, 1.0},
   red    = { 1.0, 0.0, 0.0, 1.0},
   green  = { 0.0, 1.0, 0.0, 1.0},
   orange = { 1.0, 0.7, 0.0, 1.0}
}

local keys = {
   _spacer_ = "XXXXXXXXXXXXXXXX",
   network  = "Network config",
   ethmac   = "Ethernet MAC",
   ethip    = "Ethernet IPv4",
   wlanmac  = "WiFi MAC",
   wlanip   = "WiFi IPv4",
   gw       = "Gateway",
   online   = "Online status"
}

local values = {}
util.data_mapper {
   ["update/(.*)"] = function(k, v)
      values[k] = v
   end
}

local function draw_info()
   local s = math.floor(HEIGHT/16)
   local y = s*1.1

   local logo_x, logo_y = logo:size()
   logo_x = logo_x * (s*4/logo_y)
   logo:draw(s, y, s+logo_x, y+s*4)

   local title_w = font:width(title, s)
   font:write(s*0.7 + WIDTH*0.5-title_w/2, y, title, s, unpack(colors.white))
   y = y + s + s * 0.2

   local serial_s = s*2.5
   local serial_w = font:width(serial, serial_s)
   font:write(s*0.7 + WIDTH*0.5-serial_w/2, y, serial, serial_s, unpack(colors.orange))
   y = y + serial_s + s * 0.7

   line:draw(0, y-1, WIDTH, y+1)
   y = y + s * 0.42

   local k_x, v_x = WIDTH/2-font:width(keys._spacer_, s), WIDTH/2
   local function print_kv(k, v, c)
      font:write(k_x, y, k, s, unpack(colors.grey))
      font:write(v_x, y, v or "-", s, unpack(c or colors.grey))
      y = y + s*1.1
   end

   for _,k in ipairs({"network", "ethmac", "ethip", "wlanmac", "wlanip", "gw"}) do
      print_kv(keys[k], values[k])
   end
   print_kv(keys.online, values.online, (values.online == "online") and colors.green or colors.red)
   y = y + s * 0.42

   line:draw(0, y-1, WIDTH, y+1)
   y = y + s * 0.42

   tvservice = values.tvservice or "-"
   local ts_s = s*0.5
   local ts_x = WIDTH/2 - font:width(tvservice, ts_s)/2
   font:write(ts_x, y, tvservice, ts_s, unpack(colors.grey))
end

function node.render()
   gl.clear(unpack(colors.black))
   draw_info()
end
