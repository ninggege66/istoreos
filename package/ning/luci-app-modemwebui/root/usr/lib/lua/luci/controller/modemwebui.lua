module("luci.controller.modemwebui", package.seeall)

function index()
	entry({"admin", "modem", "modemwebui"}, template("modemwebui/modemwebui"), _("模组管理UI"), 10).leaf = true
	entry({"admin", "modem", "modemwebui", "heartbeat"}, call("action_heartbeat")).leaf = true
end

function action_heartbeat()
	local fs = require "nixio.fs"
	fs.writefile("/tmp/modemwebui.heartbeat", "1")
	local sys = require "luci.sys"
	if not sys.process.list("webuiserver")[1] then
		sys.call("/etc/init.d/modemwebui start >/dev/null 2>&1")
	end
	luci.http.prepare_content("application/json")
	luci.http.write_json({status = "ok"})
end
