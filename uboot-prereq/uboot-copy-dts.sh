CUSTOM_DTS="uboot-prereq/rk3399-firefly-aio-lvds.dts"
DEST_DTS="$(@D)/arch/arm/dts/rk3399-firefly-aio-lvds.dts"
cp -v "$CUSTOM_DTS" "$DEST_DTS"