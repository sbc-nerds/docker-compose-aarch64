# Dockerfile to build docker-compose for aarch64
FROM python:3.6-stretch

# Add env
ENV LANG C.UTF-8

# Enable cross-build for aarch64
#COPY ./vendor/qemu-bin /usr/bin/
#RUN [ "cross-build-start" ]

# Set the versions
ENV DOCKER_COMPOSE_VER 1.24.0
RUN pip install --upgrade pip

# Clone docker-compose
WORKDIR /build/dockercompose
RUN git clone https://github.com/docker/compose.git . \
    && git checkout $DOCKER_COMPOSE_VER

# Run the build steps (taken from github.com/docker/compose/script/build/linux-entrypoint)
RUN mkdir ./dist \
    && pip install -q -r requirements.txt -r requirements-build.txt \
    && ./script/build/write-git-sha \
    && pyinstaller docker-compose.spec \
    && mv dist/docker-compose ./docker-compose-$(uname -s)-$(uname -m)

# Disable cross-build for aarch64
# Note: don't disable this, since we want to run this container on x86_64, not aarch64
# RUN [ "cross-build-end" ]

# Copy out the generated binary
VOLUME /dist
CMD cp docker-compose-* /dist
