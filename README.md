# Description
Sloop is a Raspberry Pi image generator that uses [pi-gen](https://github.com/RPi-Distro/pi-gen) to create its images. Each image is set up with the following configuration:
* Pyenv, SDKMan, GVM, and nvm are installed to manage environments for Python, Java, Golang, and Node, respectively.
* `root` user is configured to use an SSH key for auth, password auth disabled
* [ohmyzsh](https://ohmyz.sh/) installed
* Network configured via USB port for communication with an iPad for OTG development
* Timezone set to UTC
* Hostname configured to `dev-env`

# Usage
This package must be used in a debian environment (preferrably on a Raspberry Pi to ensure build consistency). If the SSH key needs to be changed, update the `PUBKEY_SSH_FIRST_USER` variable in `config`.

When using this image with an iPad, it will have the IP address `11.100.0.1` and the iPad will obtain an IP within the range of `11.100.0.2` - `11.100.0.6`. These IP addresses were chosen as they are incredibly unlikely to conflict with any other used IP address ranges.

If you wish to have a wlan0 connection while connected to the iPad, edit the network sections in the file `stage2/dev-env-setup/files/ipad-network`.

To build the image, run `./build.sh -c config`. Once it is complete, it will output a file in `deploy/` with a name similar to `image_$(date +"%Y-%m-%d")-sloop-lite.zip` which can be extracted to obtain the `.img` file which can then be flashed on an SD card using something like [Raspberry Pi Imager](https://www.raspberrypi.com/software/)

# Roadmap
* Support pulling in custom wlan0 config file
