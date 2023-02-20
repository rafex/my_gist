#!/bin/bash

# run script with root

VERSION_NODEJS="19.6.0"
BASE_PATH="/opt/nodejs"

curl --create-dirs -O --output-dir ${BASE_PATH} https://nodejs.org/dist/v${VERSION_NODEJS}/node-v${VERSION_NODEJS}-linux-x64.tar.xz

mkdir -p ${BASE_PATH}/${VERSION_NODEJS}

chmod 755 ${BASE_PATH}

tar -xvf ${BASE_PATH}/node-v${VERSION_NODEJS}-linux-x64.tar.xz --directory ${BASE_PATH}/${VERSION_NODEJS}

mv ${BASE_PATH}/${VERSION_NODEJS}/node-v${VERSION_NODEJS}-linux-x64/* ${BASE_PATH}/${VERSION_NODEJS}/

rm -rf ${BASE_PATH}/${VERSION_NODEJS}/node-v${VERSION_NODEJS}-linux-x64


#ln -s ${BASE_PATH}/${VERSION_NODEJS}/bin/node /usr/bin/node
#ln -s ${BASE_PATH}/${VERSION_NODEJS}/bin/corepack /usr/bin/corepack
#ln -s ${BASE_PATH}/${VERSION_NODEJS}/bin/npm /usr/bin/npm
#ln -s ${BASE_PATH}/${VERSION_NODEJS}/bin/npx /usr/bin/npx

update-alternatives --install /usr/bin/node node ${BASE_PATH}/${VERSION_NODEJS}/bin/node 10
update-alternatives --install /usr/bin/nodejs nodejs ${BASE_PATH}/${VERSION_NODEJS}/bin/node 10
update-alternatives --install /usr/bin/corepack corepack ${BASE_PATH}/${VERSION_NODEJS}/bin/corepack 10
update-alternatives --install /usr/bin/npm npm ${BASE_PATH}/${VERSION_NODEJS}/bin/npm 10
update-alternatives --install /usr/bin/npx npx ${BASE_PATH}/${VERSION_NODEJS}/bin/npx 10
