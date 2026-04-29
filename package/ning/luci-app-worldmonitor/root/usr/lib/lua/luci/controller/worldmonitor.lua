module("luci.controller.worldmonitor", package.seeall)

function index()
	entry({"admin", "services", "worldmonitor"}, template("worldmonitor/worldmonitor"), _("世界监控"), 60).leaf = true
end
