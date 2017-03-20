all: build

build:
	docker build . -t radius314/bmlt-vox:latest

debug:
	docker run -it --name freeswitch \
				--entrypoint=/bin/bash \
				-p 5060:5060/tcp \
				-p 5060:5060/udp \
				-p 5080:5080/tcp \
				-p 5080:5080/udp \
				-p 8080:8080/tcp \
				-p 16400-16410:16400-16410/udp \
				radius314/bmlt-vox:latest

run:
	docker run -i --name freeswitch \
				-p 5060:5060/tcp \
				-p 5060:5060/udp \
				-p 5080:5080/tcp \
				-p 5080:5080/udp \
				-p 8080:8080/tcp \
				-p 16400-16410:16400-16410/udp \
				radius314/bmlt-vox:latest
