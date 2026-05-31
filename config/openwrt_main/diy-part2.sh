#!/bin/bash
set -e

OPENWRT_IP="${1:-192.168.1.1}"
USE_CCACHE="${2:-true}"

echo "diy-part2: N1 edge-server customization"

# ---------- Build acceleration ----------
if [ "${USE_CCACHE}" = "true" ]; then
  grep -q "CONFIG_CCACHE=y" .config || echo "CONFIG_CCACHE=y" >> .config
fi

# ---------- Hostname / banner ----------
sed -i "s/OpenWrt/N1-Edge/g" package/base-files/files/bin/config_generate || true

# ---------- Docker default config tweak ----------
# dockerd package will create its default config; real data-root will be adjusted on device after mounting external disk.
# Do not hardcode a non-existing /mnt path here, otherwise dockerd may fail to start on first boot.

# ---------- Optional: include ophub LuCI Amlogic panel ----------
# CLI-only server does not need this. Uncomment if you want Web UI install/upgrade panel.
# rm -rf package/luci-app-amlogic
# git clone --depth=1 https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
# grep -q "CONFIG_PACKAGE_luci-app-amlogic=y" .config || echo "CONFIG_PACKAGE_luci-app-amlogic=y" >> .config
