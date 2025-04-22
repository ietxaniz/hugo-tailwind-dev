FROM node:22.14.0-slim

RUN apt-get update && apt-get install -y \
    wget \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/gohugoio/hugo/releases/download/v0.146.6/hugo_0.146.6_linux-amd64.deb && \
    apt install -y ./hugo_0.146.6_linux-amd64.deb && \
    rm hugo_0.146.6_linux-amd64.deb

RUN curl -Lo /usr/local/bin/tailwindcss https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-x64 && \
    chmod +x /usr/local/bin/tailwindcss

WORKDIR /site

EXPOSE 1313

CMD ["hugo", "server", "--bind", "0.0.0.0", "--baseURL", "http://localhost:1313", "--appendPort=false" "--noHTTPCache" "--disableFastRender"]
