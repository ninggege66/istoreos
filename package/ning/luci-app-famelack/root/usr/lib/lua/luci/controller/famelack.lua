module("luci.controller.famelack", package.seeall)

function index()
	entry({"admin", "services", "famelack"}, template("famelack/famelack"), _("直播电视"), 61).leaf = true
end
