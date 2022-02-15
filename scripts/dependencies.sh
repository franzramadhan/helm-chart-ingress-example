# /usr/bin/env bash

if ! [ -x "$(command -v brew)" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install \
    docker \
    docker-compose \
    kubectl \
    kind \
    helm \
    pwgen \
    cmake \
    automake
