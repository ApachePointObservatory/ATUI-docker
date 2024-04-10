# ATUI-docker

This is a repository that holds the configuration and build files needed run Apache Point Observatory's TUI software with the Apollo Instrument extensions in a Docker container. * *Note:* * these instructions are similar to the ***TUI3-docker*** instructions, but have some notable differences. Please continue carefully.

## Build Instructions

### MacOS Prerequisites

Install [Docker Desktop](https://www.docker.com/) (mandatory).

Install [XQuartz](https://www.xquartz.org/) (mandatory). Open the XQuartz preferences, go to the **Security** tab, and check **Allow connections from network clients** and uncheck **Authenticate Connections**. Close the window and reboot your Mac.

Install pulseaudio using [Brew](https://formulae.brew.sh/formula/repo) (optional, if you want sound). Reboot your Mac. Open a terminal and do ```pulseaudio -D --exit-idle-time=-1 --load=module-native-protocol-tcp``` to  start pulseaudio, then check your audio by doing ```pacmd play-sample 0 1```.

Edit the file ```docker-compose.yml```. Uncomment the lines that terminate in ```#uncomment for MacOS```. The relevant lines of the ```docker-compose.yml``` file should look like:
```
    volumes:
      - /tmp/.X11-unix/:/tmp/.X11-unix                #uncomment for MacOS or Linux
      - ${HOME}/.config/pulse:/root/.config/pulse     #uncomment for MacOS or Linux
      - image-downloads:/root:rw
    environment:
      - DISPLAY=host.docker.internal:0		#uncomment for MacOS
      - PULSE_SERVER=host.docker.internal	#uncomment for MacOS
      #- DISPLAY=${DISPLAY}                            #uncomment for Linux
      #- PULSE_SERVER=10.3.0.1                         #uncomment for Linux
```
Proceed to section ***All Platforms***.

### Linux Prerequisites

Do not install Docker from your distribution's package repositories. Follow the [instructions documented on Docker's website](https://docs.docker.com/engine/) to install Docker. You may either install the Docker Engine CLI or Docker Desktop.

If you opt for Docker Desktop, follow the MacOS install instructions with regard to the ```docker-compose.yml``` file above (*i.e.* do not install XQuartz, and install pulseaudio as described in the following step).

Install pulseaudio from your distribution's package repositories. Open a terminal and do ```pulseaudio -D --exit-idle-time=-1 --load=module-native-protocol-tcp``` to  start pulseaudio, then check your audio by doing ```pacmd play-sample 0 1```.

Edit the file ```docker-compose.yml```. Uncomment the lines that terminate in ```#uncomment for Linux```. The relevant lines should look as follows
```
    volumes:
      - /tmp/.X11-unix/:/tmp/.X11-unix                #uncomment for MacOS or Linux
      - ${HOME}/.config/pulse:/root/.config/pulse     #uncomment for MacOS or Linux
      - image-downloads:/root:rw
    environment:
      #- DISPLAY=host.docker.internal:0      #uncomment for MacOS
      #- PULSE_SERVER=host.docker.internal:0   #uncomment for MacOS
      - DISPLAY=${DISPLAY}                            #uncomment for Linux
      - PULSE_SERVER=10.3.0.1                         #uncomment for Linux
```
Proceed to section ***All Platforms***.

### Windows Prerequisites

Instructions coming soon.

### All Platforms

Download the the necessary source tree for Apollo from the Apollo3 git repository. This repository is * *private* *, so contact APO personnel to gain access. Place the Apollo3 source in the directory ```<path-to-this-ATUI-docker-repo>/python/Apollo/```. edit the ```pathStuff.py``` file and use ```/workdir/python/``` as your home directory.

That is, edit the following lines to look as follows:
```
sys.path.append("/usr/local/lib/python3.10/dist-packages")
...
path = "/workdir/python/TUIAdditions/Apollo/" # yes end backslashes!
...
path = "/workdir/python/TUIAdditions/Apollo/images/" # yes end backslashes!
...
dataDir = "/workdir/python/TUIAdditions/Apollo/data/" # yes end backslashes!
...
return "/workdir/python/TUIAdditions/Apollo/ephem/moon_pos.py"
```

Install either the Docker engine or Docker Desktop. ```cd``` to the directory to where this repository was cloned and using the CLI do
```
xhost +
docker compose build
docker compose up
```
The first command allows XWindows info to be passed between the Docker container and the host's (your) desktop. The second command will build the tui docker image using ```docker compose```. Finally, the third command will run a container using the built image using the parameters stored in ```docker-compose.yml```. If you can see all the TUI windows pop up, contratulations!


## Run Instructions

To run your docker container after the initial build and run, first open a terminal and do ```xhost +```. Your new TUI container can be restarted from Docker Desktop or from the command line by doing ```docker start atui3```. Alternatively, ```docker compose up``` can be run from the location of the ```docker-compose.yml``` file.

To access a ```bash``` shell within the ```atui3``` container, open a terminal and do ```docker exec -it atui3 /bin/bash```. This will allow you do bring up the root plots window, or to do other admin tasks within the container.
