# ref: https://github.com/microsoft/playwright/blob/master/docs/docker/Dockerfile.bionic
FROM ubuntu:bionic

ENV NODEJS_VERSION 12

# 1. Install Node.js
RUN apt-get update && apt-get install -y curl && \
    curl -sL https://deb.nodesource.com/setup_$NODEJS_VERSION.x | bash - && \
    apt-get install -y nodejs

# 2. Install WebKit dependencies
RUN apt-get install -y libwoff1 \
                       libopus0 \
                       libwebp6 \
                       libwebpdemux2 \
                       libenchant1c2a \
                       libgudev-1.0-0 \
                       libsecret-1-0 \
                       libhyphen0 \
                       libgdk-pixbuf2.0-0 \
                       libegl1 \
                       libnotify4 \
                       libxslt1.1 \
                       libevent-2.1-6 \
                       libgles2 \
                       libvpx5

# 3. Install Chromium dependencies
RUN apt-get install -y libnss3 \
                       libxss1 \
                       libasound2

# 4. Install Firefox dependencies
RUN apt-get install -y libdbus-glib-1-2

# 5. Install ffmpeg to bring in audio and video codecs necessary for playing videos in Firefox.
RUN apt-get install -y ffmpeg

# 6. Add user so we don't need --no-sandbox in Chromium
RUN groupadd -r appuser && useradd -r -g appuser -G audio,video appuser \
    && mkdir -p /home/appuser/Downloads \
    && chown -R appuser:appuser /home/appuser

# 7. Install XVFB if there's a need to run browsers in headful mode
RUN apt-get install -y xvfb

# Run everything after as non-privileged user.
USER appuser

CMD ["/bin/bash"]
