NODE_BUILD_NUM=5822084

curl https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1/testnet-config.json -o testnet-config.json
curl https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1/testnet-byron-genesis.json -o testnet-byron-genesis.json 
curl https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1/testnet-shelley-genesis.json -o testnet-shelley-genesis.json
curl https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1/testnet-topology.json -o testnet-topology.json
curl https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1/testnet-db-sync-config.json -o testnet-db-sync-config.json
curl https://hydra.iohk.io/build/${NODE_BUILD_NUM}/download/1/rest-config.json -o rest-config.json