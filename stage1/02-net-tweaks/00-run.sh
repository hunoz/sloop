***REMOVED***

echo "${TARGET_HOSTNAME***REMOVED***" > "${ROOTFS_DIR***REMOVED***/etc/hostname"
echo "127.0.1.1		${TARGET_HOSTNAME***REMOVED***" >> "${ROOTFS_DIR***REMOVED***/etc/hosts"

ln -sf /dev/null "${ROOTFS_DIR***REMOVED***/etc/systemd/network/99-default.link"
