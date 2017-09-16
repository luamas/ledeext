-- Copyright 2014-2016 Sandor Balazsi <sandor.balazsi@gmail.com>
-- Licensed to the public under the Apache License 2.0.

m = Map("rtorrent", translate("RSS Downloader"))

m.redirect = luci.dispatcher.build_url("admin/nas/rtorrent_config")

s = m:section(TypedSection, "rss-rule")
s.addremove = true
s.anonymous = true
s.sortable = true
s.template = "cbi/tblsection"
s.extedit = luci.dispatcher.build_url("admin/nas/rtorrent_config_rss_rule_detail/%s")
s.template_addremove = "rtorrent/rss_addrule"

function s.parse(self, ...)
	TypedSection.parse(self, ...)

	local newrule_name = m:formvalue("_newrule.name")
	local newrule_submit = m:formvalue("_newrule.submit")

	if newrule_submit then
		newrule = TypedSection.create(self, section)
		self.map:set(newrule, "name", newrule_name)

		m.uci:save("rtorrent")
		luci.http.redirect(luci.dispatcher.build_url("admin/nas/rtorrent_config_rss_rule_detail", newrule))
	end
end

name = s:option(DummyValue, "name", translate("Name"))
name.width = "30%"

match = s:option(DummyValue, "match", translate("Match"))
match.width = "60%"

enabled = s:option(Flag, "enabled", translate("Enabled"))
enabled.rmempty = false

return m

