include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-routerdog
PKG_VERSION:=1.4.10
PKG_RELEASE:=1

PKG_LICENSE:=Apache-2.0
PKG_MAINTAINER:=Carseason

PKG_SOURCE:=routergo-binary-0.14.10.tar.gz
PKG_SOURCE_URL:=https://github.com/Carseason/openwrt-packages/releases/download/prebuilt/
PKG_HASH:=5d405c7baf342b0a48d11fe9faac372966e459cefdfcb28f7aef424b9aa520a1
PKG_BUILD_DIR:=$(BUILD_DIR)/routergo-binary-0.14.10

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=RouterDog - Dashboard & Desktop (Full)
	DEPENDS:=@(x86_64||aarch64||arm) +docker +luci-base +luci-app-store +luci-lib-taskd
	PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
  RouterDog is a dashboard & user guide with a desktop-like interface.
  This package includes both the routergo backend and the LuCI frontend.
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	# 1. Install Backend (RouterGo)
	$(INSTALL_DIR) $(1)/usr/sbin $(1)/etc/init.d $(1)/etc/uci-defaults $(1)/etc/config
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/routergo.$(ARCH) $(1)/usr/sbin/routergo
	$(INSTALL_BIN) ./files/routergo.init $(1)/etc/init.d/routergo
	$(INSTALL_BIN) ./files/routergo.uci-default $(1)/etc/uci-defaults/09-routergo
	$(INSTALL_CONF) ./files/routergo.config $(1)/etc/config/routergo

	# 2. Install Frontend (LuCI)
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	[ -d ./luasrc ] && cp -pR ./luasrc/* $(1)/usr/lib/lua/luci/ || true
	
	$(INSTALL_DIR) $(1)/www/luci-static/routerdog
	[ -d ./htdocs/luci-static/routerdog ] && cp -pR ./htdocs/luci-static/routerdog/* $(1)/www/luci-static/routerdog/ || true
	
	$(INSTALL_DIR) $(1)/usr/share/luci/menu.d
	[ -d ./root/usr/share/luci/menu.d ] && cp -pR ./root/usr/share/luci/menu.d/* $(1)/usr/share/luci/menu.d/ || true

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./root/etc/config/routerdog $(1)/etc/config/routerdog
	
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./root/etc/uci-defaults/50_luci-routerdog $(1)/etc/uci-defaults/50_luci-routerdog

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	[ -f ./po/zh-cn/routerdog.po ] && po2lmo ./po/zh-cn/routerdog.po $(1)/usr/lib/lua/luci/i18n/routerdog.zh-cn.lmo || true
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/routergo
/etc/config/routerdog
endef

$(eval $(call BuildPackage,$(PKG_NAME)))