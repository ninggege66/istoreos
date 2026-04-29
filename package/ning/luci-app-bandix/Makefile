include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-bandix
PKG_VERSION:=0.12.8
PKG_RELEASE:=1

PKG_LICENSE:=Apache-2.0
PKG_MAINTAINER:=timsaya

include $(INCLUDE_DIR)/package.mk

# Binary configuration for backend
# Manually define the target arch to avoid triggering the heavy Rust host build
ifeq ($(ARCH),aarch64)
	BANDIX_ARCH:=aarch64-unknown-linux-musl
	PKG_HASH:=8df5f5964e903b51b45a1b4f549bb956a5882b940eb971eb670536e3dbd116b7
else ifeq ($(ARCH),x86_64)
	BANDIX_ARCH:=x86_64-unknown-linux-musl
	PKG_HASH:=f2f2fd4683182a68fd6bc3ce52c3b60bf5123f30282ee0b207b28db2947f0bf4
else
	BANDIX_ARCH:=unknown
	PKG_HASH:=dummy
endif

RUST_BINARY_FILENAME:=bandix-$(PKG_VERSION)-$(BANDIX_ARCH).tar.gz
PKG_SOURCE:=$(RUST_BINARY_FILENAME)
PKG_SOURCE_URL:=https://github.com/timsaya/bandix/releases/download/v$(PKG_VERSION)

define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=Bandix Traffic Monitor (Full)
	DEPENDS:=+luci-base +luci-lib-jsonc +curl +zoneinfo-all +conntrack +iw
	PKGARCH:=all
endef

define Package/$(PKG_NAME)/description
	Bandix network traffic monitoring tool with LuCI interface.
	This package includes both the backend service and the frontend UI.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)/bin
	gzip -dc "$(DL_DIR)/$(PKG_SOURCE)" | tar -C $(PKG_BUILD_DIR)/bin --strip-components=1 -xf -
	$(Build/Patch)
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	# 1. Install Backend Service
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bin/bandix $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_BIN) ./files/bandix.init $(1)/etc/init.d/bandix
	$(INSTALL_CONF) ./files/bandix.config $(1)/etc/config/bandix
	
	$(INSTALL_DIR) $(1)/lib/upgrade/keep.d
	$(INSTALL_DATA) ./files/bandix.keep $(1)/lib/upgrade/keep.d/bandix

	# 2. Install Frontend (LuCI)
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	[ -d ./luasrc ] && cp -pR ./luasrc/* $(1)/usr/lib/lua/luci/ || true
	
	$(INSTALL_DIR) $(1)/www/luci-static/resources/view/bandix
	$(INSTALL_DATA) ./htdocs/luci-static/resources/view/bandix/*.js $(1)/www/luci-static/resources/view/bandix/
	
	$(INSTALL_DIR) $(1)/usr/share/luci/menu.d
	$(INSTALL_DATA) ./root/usr/share/luci/menu.d/*.json $(1)/usr/share/luci/menu.d/
	
	$(INSTALL_DIR) $(1)/usr/share/luci/status
	$(INSTALL_DATA) ./root/usr/share/luci/status/*.json $(1)/usr/share/luci/status/

	$(INSTALL_DIR) $(1)/usr/share/rpcd/acl.d
	$(INSTALL_DATA) ./root/usr/share/rpcd/acl.d/*.json $(1)/usr/share/rpcd/acl.d/
	
	$(INSTALL_DIR) $(1)/usr/libexec/rpcd
	$(INSTALL_BIN) ./root/usr/libexec/rpcd/luci.bandix $(1)/usr/libexec/rpcd/

	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	[ -f ./po/zh_Hans/bandix.po ] && po2lmo ./po/zh_Hans/bandix.po $(1)/usr/lib/lua/luci/i18n/bandix.zh-cn.lmo || true
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/bandix
endef

$(eval $(call BuildPackage,$(PKG_NAME)))