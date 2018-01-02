***REMOVED***

DOCKER="docker"
set +e
$DOCKER ps >/dev/null 2>&1
if [ $? != 0 ]; then
	DOCKER="sudo docker"
fi
if ! $DOCKER ps >/dev/null; then
	echo "error connecting to docker:"
	$DOCKER ps
	exit 1
fi
set -e

config_file=()
if [ -f config ]; then
	config_file=("--env-file" "$(pwd)/config")
	source config
fi

CONTAINER_NAME=${CONTAINER_NAME:-pigen_work***REMOVED***
CONTINUE=${CONTINUE:-0***REMOVED***

if [ "$*" != "" ] || [ -z "${IMG_NAME***REMOVED***" ]; then
	if [ -z "${IMG_NAME***REMOVED***" ]; then
		echo "IMG_NAME not set in 'config'" 1>&2
		echo 1>&2
	fi
	cat >&2 <<***REMOVED***
Usage:
    build-docker.sh [options]
Optional environment arguments: ( =<default> )
    CONTAINER_NAME=pigen_work  set a name for the build container
    CONTINUE=1                 continue from a previously started container
***REMOVED***
	exit 1
fi

CONTAINER_EXISTS=$($DOCKER ps -a --filter name="$CONTAINER_NAME" -q)
CONTAINER_RUNNING=$($DOCKER ps --filter name="$CONTAINER_NAME" -q)
if [ "$CONTAINER_RUNNING" != "" ]; then
	echo "The build is already running in container $CONTAINER_NAME. Aborting."
	exit 1
fi
if [ "$CONTAINER_EXISTS" != "" ] && [ "$CONTINUE" != "1" ]; then
	echo "Container $CONTAINER_NAME already exists and you did not specify CONTINUE=1. Aborting."
	echo "You can delete the existing container like this:"
	echo "  $DOCKER rm -v $CONTAINER_NAME"
	exit 1
fi

$DOCKER build -t pi-gen .
if [ "$CONTAINER_EXISTS" != "" ]; then
	trap "echo 'got CTRL+C... please wait 5s'; $DOCKER stop -t 5 ${CONTAINER_NAME***REMOVED***_cont" SIGINT SIGTERM
	time $DOCKER run --rm --privileged \
		--volumes-from="${CONTAINER_NAME***REMOVED***" --name "${CONTAINER_NAME***REMOVED***_cont" \
		-e IMG_NAME=${IMG_NAME***REMOVED***\
		pi-gen \
		bash -e -o pipefail -c "dpkg-reconfigure qemu-user-static &&
	cd /pi-gen; ./build.sh;
	rsync -av work/*/build.log deploy/" &
	wait "$!"
else
	trap "echo 'got CTRL+C... please wait 5s'; $DOCKER stop -t 5 ${CONTAINER_NAME***REMOVED***" SIGINT SIGTERM
	time $DOCKER run --name "${CONTAINER_NAME***REMOVED***" --privileged \
		-e IMG_NAME=${IMG_NAME***REMOVED***\
		"${config_file[@]***REMOVED***" \
		pi-gen \
		bash -e -o pipefail -c "dpkg-reconfigure qemu-user-static &&
	cd /pi-gen; ./build.sh &&
	rsync -av work/*/build.log deploy/" &
	wait "$!"
fi
echo "copying results from deploy/"
$DOCKER cp "${CONTAINER_NAME***REMOVED***":/pi-gen/deploy .
ls -lah deploy
$DOCKER rm -v $CONTAINER_NAME

echo "Done! Your image(s) should be in deploy/"
