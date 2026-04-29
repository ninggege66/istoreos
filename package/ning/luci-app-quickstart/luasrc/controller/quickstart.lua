module("luci.controller.quickstart", package.seeall)

function index()
    -- API 接口
    local e
    e = entry({"admin", "quickstart", "auto_setup"}, post("auto_setup"))
    e.sysauth = false

    e = entry({"admin", "quickstart", "setup_result"}, call("setup_result"))
    e.sysauth = false

    e = entry({"admin", "quickstart", "webui_path"}, call("get_webui_path"))
    e.sysauth = false

    e = entry({"admin", "quickstart", "dynamic_menus"}, call("get_dynamic_menus"))
    e.sysauth = false

    -- 兼容旧路径，统一跳回前端实际挂载点
    entry({"admin", "nas", "quickstart"}, call("redirect_fallback")).leaf = true
    entry({"admin", "nas", "quickstart", "index"}, call("redirect_fallback")).leaf = true
end

function redirect_fallback()
    luci.http.redirect(luci.dispatcher.build_url("admin", "quickstart"))
end

function get_webui_path()
    local fs = require "nixio.fs"
    local ui_type = "000"
    local cache = fs.readfile("/etc/modemwebui/device.cache")
    if cache then
        if cache:find("webui5700") then
            ui_type = "5700"
        end
    end
    luci.http.prepare_content("application/json")
    luci.http.write_json({ 
        type = ui_type,
        base = "/webui/webui" .. ui_type .. "/web/"
    })
end

local function build_dynamic_menus()
    local dispatcher = require "luci.dispatcher"
    local i18n = require "luci.i18n"
    local menu = dispatcher.menu_json()
    local results = {}
    local seen = {}
    local parent_paths = {
        { "admin", "modem" },
        { "admin", "services" }
    }

    local function get_node(root, segments)
        local node = root
        for _, segment in ipairs(segments) do
            if type(node) ~= "table" then
                return nil
            end
            node = node[segment]
        end
        return node
    end

    local function is_visible(node)
        if type(node) ~= "table" then
            return false
        end
        if node.hidden or node.dependent == false then
            return false
        end
        return node.title ~= nil and node.title ~= ""
    end

    local function add_children(parent_segments)
        local parent = get_node(menu, parent_segments)
        if type(parent) ~= "table" then
            return
        end

        for key, node in pairs(parent) do
            if is_visible(node) then
                local path = table.concat({
                    parent_segments[1],
                    parent_segments[2],
                    key
                }, "/")

                if not seen[path] then
                    results[#results + 1] = {
                        title = i18n.translate(node.title) or key,
                        path = path,
                        order = tonumber(node.order) or 1000
                    }
                    seen[path] = true
                end
            end
        end
    end

    for _, parent_segments in ipairs(parent_paths) do
        add_children(parent_segments)
    end

    table.sort(results, function(a, b)
        if a.order == b.order then
            return a.title < b.title
        end
        return a.order < b.order
    end)

    return results
end

function get_dynamic_menus()
    luci.http.prepare_content("application/json")
    luci.http.write_json(build_dynamic_menus())
end

function auto_setup()
    luci.http.prepare_content("application/json")
    luci.http.write_json({success=0})
end

function setup_result()
    luci.http.prepare_content("application/json")
    luci.http.write_json({success=0, result={ongoing=false}})
end
