--[[

  this based on node.lua from:
  https://github.com/info-beamer/package-installation-help
  this repo has the following license:


  Copyright (C) 2016 Florian Wesch <fw@dividuum.de>

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.

]]--

util.init_hosted()
util.noglobals()

NATIVE_WIDTH = NATIVE_WIDTH or 1920
NATIVE_HEIGHT = NATIVE_HEIGHT or 1080

node.set_flag("no_clear")

gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local font = CONFIG.font
local logo = CONFIG.logo:ensure_loaded()
local title = CONFIG.title
local gray = resource.create_colored_texture(1,1,1,0.5)
local v = {
    serial = sys.get_env "SERIAL"
}
util.data_mapper{
    ["update/(.*)"] = function(key, val)
        v[key] = val
    end
}

local function draw_info()
    local size, k_x, v_x, y, l_x, l_y
    size = math.floor(HEIGHT/20)
    y = 30+size*6
    k_x, v_x = 30, 30+font:width("XXXXXXXXXXXXXXXX", size)
    l_x, l_y = logo:size()
    l_y = l_y * (size*4/l_x)
    --    util.draw_correct(logo, 30, 30, WIDTH/2-30, 30+size*5)
    logo:draw(30, 30, 30+size*4, 30+l_y)

    if title ~= "" then
       font:write(60, 30, title, size, 1,1,1,.5)
    end

    if v.serial then
        local s = math.min(400, size*4)
        local w = font:width(v.serial, s)
        local x = WIDTH*0.5
        local y = 100
        font:write(x-w/2, y-s/2, v.serial, s, 1,1,1,1)
    end

    gray:draw(0, HEIGHT*0.4-1, WIDTH, HEIGHT*0.4+1)

    local function key(str)
        font:write(k_x, y, str, size, 1,1,1,.5)
    end
    local function val(str, col)
        col = col or {1,1,1,.5}
        font:write(v_x, y, str, size, unpack(col))
        y = y + size*1.1
    end

    if v.network then
        key "Network config"
        val(v.network)
    end

    if v.ethmac then
        key "Ethernet MAC"
        val(v.ethmac)
    end

    if v.ethip then
        key "Ethernet IPv4"
        val(v.ethip)
    end

    if v.wlanmac then
        key "WiFi MAC"
        val(v.wlanmac)
    end

    if v.wlanip then
        key "WiFi IPv4"
        val(v.wlanip)
    end

    if v.gw then
        key "Gateway"
        val(v.gw)
    end

    if v.online then
        key "Online status"
        local col = {1,0,0,1}
        if v.online == "online" then
            col = {0,1,0,1}
        end
        val(v.online, col)
    end

end

function node.render()
    gl.clear(0,0,0,1)
    draw_info()
end
