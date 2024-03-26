FROM sinusbot/docker:1.0.2-discord

LABEL description="SinusBot - TeamSpeak 3 and Discord music bot."
LABEL version="1.0.2"

# Install dependencies and clean up afterwards
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends x11vnc xvfb libxcursor1 libnss3 libegl1-mesa libasound2 libglib2.0-0 libxcomposite-dev less jq && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# Install python 3.8 for latest yt-dlp
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt install -y python3.8

# Download/Install TeamSpeak Client
RUN bash install.sh teamspeak

ADD additional-install.sh .
RUN chmod 755 additional-install.sh

# Download/Install yt-dlp
RUN bash additional-install.sh yt-dlp