***REMOVED***

IMG_FILE="${STAGE_WORK_DIR***REMOVED***/${IMG_DATE***REMOVED***-${IMG_NAME***REMOVED***${IMG_SUFFIX***REMOVED***.img"

IMGID="$(fdisk -l ${IMG_FILE***REMOVED*** | sed -n 's/Disk identifier: 0x\([^ ]*\)/\1/p')"

BOOT_PARTUUID="${IMGID***REMOVED***-01"
ROOT_PARTUUID="${IMGID***REMOVED***-02"

sed -i "s/BOOTDEV/PARTUUID=${BOOT_PARTUUID***REMOVED***/" ${ROOTFS_DIR***REMOVED***/etc/fstab
sed -i "s/ROOTDEV/PARTUUID=${ROOT_PARTUUID***REMOVED***/" ${ROOTFS_DIR***REMOVED***/etc/fstab

sed -i "s/ROOTDEV/PARTUUID=${ROOT_PARTUUID***REMOVED***/" ${ROOTFS_DIR***REMOVED***/boot/cmdline.txt
