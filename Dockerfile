FROM alpine:3.6

ADD . /go-ethereum
RUN \
  apk add --update git go make gcc musl-dev linux-headers && \
  cp go-ethereum/private/boot.key ~				  && \
  cp go-ethereum/private/genesis.json  ~                          && \    
  (cd go-ethereum && make geth)                           && \
#  (cd go-ethereum && make bootnode)                       && \
  cp go-ethereum/build/bin/geth /usr/local/bin/           && \
#  cp go-ethereum/build/bin/bootnode /usr/local/bin/           && \
  apk del git go make gcc musl-dev linux-headers          && \
#  geth init ./go-ethereum/rinkeby.json			  && \
  geth init ./go-ethereum/private/genesis.json		  && \
  cp go-ethereum/private/keystore -rf /root/.ethereum/    && \
  rm -rf /go-ethereum && rm -rf /var/cache/apk/*	 

EXPOSE 8545
EXPOSE 30303
EXPOSE 30303/udp

#ENTRYPOINT ["geth"]
ENTRYPOINT geth -verbosity 4 --ipcdisable --port 30303 --rpcport 8545 -rpc --rpcapi="db,eth,net,web3,personal,web3,admin" --rpcaddr "0.0.0.0"  --networkid=990099 --nodiscover --bootnodes enode://74b13cc21a2204fedd54712c96f5c3586539886969821871d93612ea94e8681f54a6e3aedc3f819c25b66cf225c66e3ad47d5e0d1b7e723596f2a583e700bc86@bootnode.wohshon-destinasia-util.svc.cluster.local:30301
# ENTRYPOINT bootnode --nodekey=/root/boot.key
# CMD ["/bin/sh"]
