#FROM debian:buster-slim
FROM python:3.9-buster-slim

LABEL description="SinusBot - TeamSpeak 3 and Discord music bot"
LABEL version="1.0.2"

# Install dependencies and clean up afterwards
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ca-certificates bzip2 unzip curl procps libpci3 libxslt1.1 libxkbcommon0 locales && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# Install dependencies for Teamspeak
# https://community.teamspeak.com/t/teamspeak-wont-open-after-update/42336
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libevent-2.1-6 && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# Install dependencies and clean up afterwards
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends x11vnc xvfb libxcursor1 libnss3 libegl1-mesa libasound2 libglib2.0-0 libxcomposite-dev less jq && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# Set locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

WORKDIR /opt/sinusbot

ADD installer.sh .
RUN chmod 755 installer.sh

# Download/Install SinusBot
RUN bash installer.sh sinusbot

# Download/Install yt-dlp
RUN bash installer.sh yt-dlp

# Download/Install Text-to-Speech
RUN bash installer.sh text-to-speech

# Download/Install TeamSpeak Client
RUN bash installer.sh teamspeak

ADD entrypoint.sh .
RUN chmod 755 entrypoint.sh

EXPOSE 8087

VOLUME ["/opt/sinusbot/data", "/opt/sinusbot/scripts"]

ENTRYPOINT ["/opt/sinusbot/entrypoint.sh"]

HEALTHCHECK --interval=1m --timeout=10s \
  CMD curl --no-keepalive -f http://localhost:8087/api/v1/botId || exit 1