***REMOVED***u
DIR="$( cd "$( dirname "${BASH_SOURCE[0]***REMOVED***" )" >/dev/null 2>&1 && pwd )"

BUILD_OPTS="$*"

DOCKER="docker"

if ! ${DOCKER***REMOVED*** ps >/dev/null 2>&1; then
	DOCKER="sudo docker"
fi
if ! ${DOCKER***REMOVED*** ps >/dev/null; then
	echo "error connecting to docker:"
	${DOCKER***REMOVED*** ps
	exit 1
fi

CONFIG_FILE=""
if [ -f "${DIR***REMOVED***/config" ]; then
	CONFIG_FILE="${DIR***REMOVED***/config"
fi

while getopts "c:" flag
do
	case "${flag***REMOVED***" in
		c)
			CONFIG_FILE="${OPTARG***REMOVED***"
			;;
		*)
			;;
	esac
done

# Ensure that the confguration file is present
if test -z "${CONFIG_FILE***REMOVED***"; then
	echo "Configuration file need to be present in '${DIR***REMOVED***/config' or path passed as parameter"
	exit 1
else
	# shellcheck disable=SC1090
	source "${CONFIG_FILE***REMOVED***"
fi

CONTAINER_NAME=${CONTAINER_NAME:-pigen_work***REMOVED***
CONTINUE=${CONTINUE:-0***REMOVED***
PRESERVE_CONTAINER=${PRESERVE_CONTAINER:-0***REMOVED***

if [ -z "${IMG_NAME***REMOVED***" ]; then
	echo "IMG_NAME not set in 'config'" 1>&2
	echo 1>&2
exit 1
fi

CONTAINER_EXISTS=$(${DOCKER***REMOVED*** ps -a --filter name="${CONTAINER_NAME***REMOVED***" -q)
CONTAINER_RUNNING=$(${DOCKER***REMOVED*** ps --filter name="${CONTAINER_NAME***REMOVED***" -q)
if [ "${CONTAINER_RUNNING***REMOVED***" != "" ]; then
	echo "The build is already running in container ${CONTAINER_NAME***REMOVED***. Aborting."
	exit 1
fi
if [ "${CONTAINER_EXISTS***REMOVED***" != "" ] && [ "${CONTINUE***REMOVED***" != "1" ]; then
	echo "Container ${CONTAINER_NAME***REMOVED*** already exists and you did not specify CONTINUE=1. Aborting."
	echo "You can delete the existing container like this:"
	echo "  ${DOCKER***REMOVED*** rm -v ${CONTAINER_NAME***REMOVED***"
	exit 1
fi

# Modify original build-options to allow config file to be mounted in the docker container
BUILD_OPTS="$(echo ${BUILD_OPTS:-***REMOVED*** | sed -E 's@\-c\s?([^ ]+)@-c /config@')"

${DOCKER***REMOVED*** build -t pi-gen "${DIR***REMOVED***"
if [ "${CONTAINER_EXISTS***REMOVED***" != "" ]; then
	trap 'echo "got CTRL+C... please wait 5s" && ${DOCKER***REMOVED*** stop -t 5 ${CONTAINER_NAME***REMOVED***_cont' SIGINT SIGTERM
	time ${DOCKER***REMOVED*** run --rm --privileged \
		--volume "${CONFIG_FILE***REMOVED***":/config:ro \
		--volumes-from="${CONTAINER_NAME***REMOVED***" --name "${CONTAINER_NAME***REMOVED***_cont" \
		pi-gen \
		bash -e -o pipefail -c "dpkg-reconfigure qemu-user-static &&
	cd /pi-gen; ./build.sh ${BUILD_OPTS***REMOVED*** ;
	rsync -av work/*/build.log deploy/" &
	wait "$!"
else
	trap 'echo "got CTRL+C... please wait 5s" && ${DOCKER***REMOVED*** stop -t 5 ${CONTAINER_NAME***REMOVED***' SIGINT SIGTERM
	time ${DOCKER***REMOVED*** run --name "${CONTAINER_NAME***REMOVED***" --privileged \
		--volume "${CONFIG_FILE***REMOVED***":/config:ro \
		pi-gen \
		bash -e -o pipefail -c "dpkg-reconfigure qemu-user-static &&
	cd /pi-gen; ./build.sh ${BUILD_OPTS***REMOVED*** &&
	rsync -av work/*/build.log deploy/" &
	wait "$!"
fi
echo "copying results from deploy/"
${DOCKER***REMOVED*** cp "${CONTAINER_NAME***REMOVED***":/pi-gen/deploy .
ls -lah deploy

# cleanup
if [ "${PRESERVE_CONTAINER***REMOVED***" != "1" ]; then
	${DOCKER***REMOVED*** rm -v "${CONTAINER_NAME***REMOVED***"
fi

echo "Done! Your image(s) should be in deploy/"
