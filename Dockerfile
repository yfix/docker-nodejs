FROM yfix/baseimage

ENV APP_VERSION 0.0.1
ENV APP_PATH /app
ENV NPM_CONFIG_LOGLEVEL info
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 5.7.0
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN rm /bin/sh && ln -s /bin/bash /bin/sh \
  && apt-get update && apt-get install -y -q --no-install-recommends \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    g++ \
    gcc \
    git \
    make \
    sudo \
    wget \
  \
  && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash \
  && source $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default \
  \
  && npm install -g pm2 \
  \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  \
  && echo "== the end =="

#  && mkdir -p $APP_PATH \
#  && cd $APP_PATH \
#  && npm install --production \

WORKDIR $APP_PATH

EXPOSE 80

CMD ["pm2", "start", "processes.json", "--no-daemon"]
