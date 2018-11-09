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

node.alias "install"
util.init_hosted()
util.noglobals()

NATIVE_WIDTH = NATIVE_WIDTH or 1920
NATIVE_HEIGHT = NATIVE_HEIGHT or 1080

node.set_flag("no_clear")

gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

local font = CONFIG.font
local logo = CONFIG.logo:ensure_loaded()
local title = CONFIG.title
local line = resource.create_colored_texture(1,1,1,0.5)
local serial = sys.get_env("SERIAL")

local values = {}
util.data_mapper {
    ["update/(.*)"] = function(key, val)
        values[key] = val
    end
}

local function draw_info()
    local size = math.floor(HEIGHT/16)
    local y = size

    local x_spacing, y_spacing = size * 0.3, size * 0.3
    local l_x, l_y = logo:size()
    l_x = l_x * (size*4/l_y)
    logo:draw(size, y, size+l_x, y+size*4)

    local width_title = font:width(title, size)
    font:write(WIDTH*0.5-width_title/2, y, title, size, 1, 1, 1, 1)
    y = y + size + y_spacing

    local size_serial = size*2.5
    local width_serial = font:width(serial, size_serial)
    font:write(WIDTH*0.5-width_serial/2, y, serial, size_serial, 1, 0.77, 0, 1)
    y = y + size_serial + 2*y_spacing

    line:draw(0, y-1, WIDTH, y+1)
    y = y + 3*y_spacing

    local k_x, v_x = WIDTH/2-font:width("XXXXXXXXXXXXXXXX", size), WIDTH/2
    local function key(str)
        font:write(k_x, y, str, size, 1,1,1,.5)
    end
    local function val(str, col)
        col = col or {1,1,1,.5}
        font:write(v_x, y, str, size, unpack(col))
        y = y + size*1.1
    end

    if values.network then
        key "Network config"
        val(values.network)
    end

    if values.ethmac then
        key "Ethernet MAC"
        val(values.ethmac)
    end

    if values.ethip then
        key "Ethernet IPv4"
        val(values.ethip)
    end

    if values.wlanmac then
        key "WiFi MAC"
        val(values.wlanmac)
    end

    if values.wlanip then
        key "WiFi IPv4"
        val(values.wlanip)
    end

    if values.gw then
        key "Gateway"
        val(values.gw)
    end

    if values.online then
        key "Online status"
        local col = {1,0,0,1}
        if values.online == "online" then
            col = {0,1,0,1}
        end
        val(values.online, col)
    end

end

function node.render()
    gl.clear(0,0,0,1)
    draw_info()
end
