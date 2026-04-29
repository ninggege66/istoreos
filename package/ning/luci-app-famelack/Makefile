include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-famelack
PKG_RELEASE:=1
PKG_LICENSE:=Apache-2.0

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-famelack
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=Famelack - Live World TV
  DEPENDS:=+luci-base
endef

define Package/luci-app-famelack/description
  Embeds famelack.com into LuCI for free live world TV streaming.
endef

define Build/Compile
endef

define Package/luci-app-famelack/install
	$(INSTALL_DIR) $(1)
	$(CP) ./root/. $(1)/
endef

$(eval $(call BuildPackage,luci-app-famelack))
