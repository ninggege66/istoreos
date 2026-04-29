include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-quickstart
PKG_RELEASE:=1
PKG_LICENSE:=Apache-2.0

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-quickstart
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=iStoreOS Dashboard
  DEPENDS:=+luci-base +luci-compat
endef

define Package/luci-app-quickstart/description
  iStoreOS-style dashboard homepage for LuCI (from Hiveton H5000M firmware).
endef

define Build/Compile
endef

define Package/luci-app-quickstart/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	$(CP) ./luasrc/* $(1)/usr/lib/lua/luci/
	$(INSTALL_DIR) $(1)/www
	$(CP) ./htdocs/* $(1)/www/
	$(INSTALL_DIR) $(1)/
	$(CP) ./root/* $(1)/
	$(INSTALL_BIN) ./root/usr/sbin/quickstart $(1)/usr/sbin/quickstart
	$(INSTALL_BIN) ./root/etc/init.d/quickstart $(1)/etc/init.d/quickstart
	$(INSTALL_BIN) ./root/etc/init.d/startdhns $(1)/etc/init.d/startdhns
endef

$(eval $(call BuildPackage,luci-app-quickstart))
