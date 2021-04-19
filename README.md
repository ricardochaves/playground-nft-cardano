# Playground NFT Cardano

## Before you start

You need to download the files to run `cardano-node` and` cardano-cli` on [this link](https://github.com/input-output-hk/cardano-node#linux-executable).

I tested with MacBook Pro (13-inch, M1, 2020) - Apple M1

## Run Node

The configuration files I already downloaded and put in the repo, but you can clear the config folder and run `fetch-config.sh` again.

Now run `./run-node.sh`

## Create files and keys

I divided the creation of the NFT into two parts. First you will create new addresses: Run `create-files-and-keys.sh`

See the value of the address in `$PAYMENT_ADDRES_STR`, go to the [website]((https://developers.cardano.org/en/testnets/cardano/tools/faucet/)) and ask for your coins.

Wait until the coins arrive and run the command again: 
```bash
cardano-cli query utxo --address $(cat $PAYMENT_ADDR) \
--testnet-magic 1097911063
```

You need to see:

```bash
                           TxHash                                 TxIx        Amount
--------------------------------------------------------------------------------------
cf384045d2aaf2a9f3a201679183eb7d493cecb1543a4ea8dc7f4e63a32f5336     0        1000000000 lovelace
```

## Mint

Go to the mint.sh file and update the following variables:
- `TX_HASH` with the `TxHash` value of your payment address
- `AMOUNT`with the Amount value of you payment address

In the command `cardano-cli transaction build-raw` you can configure your token name

Now run `mint.sh`

The final result will be some like that:

```bash
cardano-cli query utxo --address $(cat $PAYMENT_ADDR) \
--testnet-magic 1097911063
                           TxHash                                 TxIx        Amount
--------------------------------------------------------------------------------------
29fc3a04d222f6e5a353dca9ebe0b74d2dd98236e30134633f8c52886eaa389b     0        999819539 lovelace + 1 4e57584c04234c9d6ddd71c2738faf0bd245a91cc6af109eae3d0600.Elephant + 10 4e57584c04234c9d6ddd71c2738faf0bd245a91cc6af109eae3d0600.Iluvatar
```