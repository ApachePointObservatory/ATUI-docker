# syntax=docker/dockerfile:1

FROM ubuntu:22.04
SHELL ["/bin/bash", "-c"]
WORKDIR /workdir
## Set timezone to UTC
RUN ln -snf /usr/share/zoneinfo/UTC /etc/localtime && echo UTC > /etc/timezone

## Apollo needs to go into the home directory,
## which is /root for this docker image, unfortunately.
COPY python/Apollo python/TUIAdditions/Apollo
## Get Dependencies.
RUN apt-get update -y && 					\
	apt-get install python3 python3-pip python3-tk 		\
		wget xpa-tools saods9 git 			\
		alsa-base alsa-utils libsndfile1-dev pulseaudio \
		dpkg-dev cmake g++ gcc binutils 		\
		libx11-dev libxpm-dev libxft-dev libxext-dev 	\
		libssl-dev libpng-dev libjpeg8-dev 		\
		-y --no-install-recommends && 			\
	apt-get clean
RUN pip3 install numpy scipy Pillow matplotlib astropy pygame Pmw
RUN git clone -b 'v3.1.1beta0' https://github.com/ApachePointObservatory/TUI3.git python/TUI3
## Get the root framework, set it up.
RUN wget -O root_v6.28.00.tar.gz 		\
	https://root.cern/download/root_v6.28.00.Linux-ubuntu22-x86_64-gcc11.3.tar.gz && \
	tar -zxf root_v6.28.00.tar.gz && 	\
	rm root_v6.28.00.tar.gz && 		\
	/bin/bash -c "echo source /workdir/root/bin/thisroot.sh >> /root/.bashrc"

CMD ["python3", "python/TUI3/runtui.py"]