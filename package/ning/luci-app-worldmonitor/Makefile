include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-worldmonitor
PKG_RELEASE:=1
PKG_LICENSE:=AGPL-3.0

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-worldmonitor
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=World Monitor - Global Intelligence Dashboard
  DEPENDS:=+luci-base
endef

define Package/luci-app-worldmonitor/description
  Embeds worldmonitor.app into LuCI for real-time global news and intelligence.
endef

define Build/Compile
endef

define Package/luci-app-worldmonitor/install
	$(INSTALL_DIR) $(1)
	$(CP) ./root/. $(1)/
endef

$(eval $(call BuildPackage,luci-app-worldmonitor))
