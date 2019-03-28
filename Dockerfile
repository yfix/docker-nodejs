FROM yfix/baseimage:18.04

MAINTAINER Yuri Vysotskiy (yfix) <yfix.dev@gmail.com>

ENV APP_VERSION 0.0.1
ENV APP_PATH /app
ENV NPM_CONFIG_LOGLEVEL info
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 10.15.3
ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

RUN apt-get update && apt-get install -y -q --no-install-recommends \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    wget \
    git \
  \
  && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.4/install.sh | bash \
  && source $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default \
  \
  && npm install -g \
        pm2 \
        pm2-zabbix \
        nodemon \ 
  \
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/* \
  \
  && echo "== the end =="

RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

ENV YARN_VERSION 1.15.2

RUN mkdir -p /opt/yarn \
  && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/yarn --strip-components=1 \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn/bin/yarn /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz

WORKDIR $APP_PATH

EXPOSE 80

CMD ["pm2", "start", "processes.json", "--no-daemon"]
