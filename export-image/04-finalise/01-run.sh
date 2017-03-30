***REMOVED***

IMG_FILE="${STAGE_WORK_DIR***REMOVED***/${IMG_DATE***REMOVED***-${IMG_NAME***REMOVED***${IMG_SUFFIX***REMOVED***.img"

on_chroot << ***REMOVED***
/etc/init.d/fake-hwclock stop
hardlink -t /usr/share/doc
***REMOVED***

if [ -d ${ROOTFS_DIR***REMOVED***/home/pi/.config ]; then
	chmod 700 ${ROOTFS_DIR***REMOVED***/home/pi/.config
fi

rm -f ${ROOTFS_DIR***REMOVED***/etc/apt/apt.conf.d/51cache
rm -f ${ROOTFS_DIR***REMOVED***/usr/sbin/policy-rc.d
rm -f ${ROOTFS_DIR***REMOVED***/usr/bin/qemu-arm-static
if [ -e ${ROOTFS_DIR***REMOVED***/etc/ld.so.preload.disabled ]; then
        mv ${ROOTFS_DIR***REMOVED***/etc/ld.so.preload.disabled ${ROOTFS_DIR***REMOVED***/etc/ld.so.preload
fi

rm -f ${ROOTFS_DIR***REMOVED***/etc/apt/sources.list~
rm -f ${ROOTFS_DIR***REMOVED***/etc/apt/trusted.gpg~

rm -f ${ROOTFS_DIR***REMOVED***/etc/passwd-
rm -f ${ROOTFS_DIR***REMOVED***/etc/group-
rm -f ${ROOTFS_DIR***REMOVED***/etc/shadow-
rm -f ${ROOTFS_DIR***REMOVED***/etc/gshadow-

rm -f ${ROOTFS_DIR***REMOVED***/var/cache/debconf/*-old
rm -f ${ROOTFS_DIR***REMOVED***/var/lib/dpkg/*-old

rm -f ${ROOTFS_DIR***REMOVED***/usr/share/icons/*/icon-theme.cache

rm -f ${ROOTFS_DIR***REMOVED***/var/lib/dbus/machine-id

true > ${ROOTFS_DIR***REMOVED***/etc/machine-id

for _FILE in $(find ${ROOTFS_DIR***REMOVED***/var/log/ -type f); do
	true > ${_FILE***REMOVED***
done

rm -f "${ROOTFS_DIR***REMOVED***/root/.vnc/private.key"

update_issue $(basename ${EXPORT_DIR***REMOVED***)
install -m 644 ${ROOTFS_DIR***REMOVED***/etc/rpi-issue ${ROOTFS_DIR***REMOVED***/boot/issue.txt
install files/LICENSE.oracle ${ROOTFS_DIR***REMOVED***/boot/

ROOT_DEV=$(mount | grep "${ROOTFS_DIR***REMOVED*** " | cut -f1 -d' ')

unmount ${ROOTFS_DIR***REMOVED***
zerofree -v ${ROOT_DEV***REMOVED***

unmount_image ${IMG_FILE***REMOVED***

mkdir -p ${DEPLOY_DIR***REMOVED***

rm -f ${DEPLOY_DIR***REMOVED***/image_${IMG_DATE***REMOVED***-${IMG_NAME***REMOVED***${IMG_SUFFIX***REMOVED***.zip

echo zip ${DEPLOY_DIR***REMOVED***/image_${IMG_DATE***REMOVED***-${IMG_NAME***REMOVED***${IMG_SUFFIX***REMOVED***.zip ${IMG_FILE***REMOVED***
pushd ${STAGE_WORK_DIR***REMOVED*** > /dev/null
zip ${DEPLOY_DIR***REMOVED***/image_${IMG_DATE***REMOVED***-${IMG_NAME***REMOVED***${IMG_SUFFIX***REMOVED***.zip $(basename ${IMG_FILE***REMOVED***)
popd > /dev/null
