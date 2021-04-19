#!/bin/bash          

PAYMENT_VKEY_FILE="payment.vkey"
PAYMENT_SKEY_FILE="payment.skey"

PAYMENT_ADDR="payment.addr"
PROTOCOL_FILE_JSON="protocol.json"

POLICY_VKEY_FILE="policy.vkey"
POLICY_SKEY_FILE="policy.skey"

POLICY_SCRIPT_FILE="policy.script"

MATX_RW_FILE="matx.raw"

# RESET

rm $PAYMENT_VKEY_FILE
rm $PAYMENT_SKEY_FILE
rm $PAYMENT_ADDR
rm $PROTOCOL_FILE_JSON
rm $POLICY_SKEY_FILE
rm $POLICY_VKEY_FILE
rm $POLICY_SCRIPT_FILE
rm $MATX_RW_FILE

cardano-cli address key-gen \
    --verification-key-file $PAYMENT_VKEY_FILE \
    --signing-key-file $PAYMENT_SKEY_FILE
    --testnet-magic 1097911063

echo "+++++++++++++++++++++++"
echo "Generated Keys on files: " $PAYMENT_VKEY_FILE " and " $PAYMENT_SKEY_FILE
echo "+++++++++++++++++++++++"

cardano-cli address build \
    --payment-verification-key-file $PAYMENT_VKEY_FILE \
    --out-file $PAYMENT_ADDR \
    --testnet-magic 1097911063

PAYMENT_ADDRESS_STR=$(cat $PAYMENT_ADDR)

echo "+++++++++++++++++++++++"
echo "Payment addres: " $PAYMENT_ADDRESS_STR
echo "+++++++++++++++++++++++"

echo "+++++++++++++++++++++++"
echo "Now we will check UTXo of address:"
cardano-cli query utxo --address $PAYMENT_ADDRESS_STR \
--testnet-magic 1097911063
echo "+++++++++++++++++++++++"

