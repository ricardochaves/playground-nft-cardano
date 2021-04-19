#!/bin/bash  


PAYMENT_VKEY_FILE="payment.vkey"
PAYMENT_SKEY_FILE="payment.skey"

PAYMENT_ADDR="payment.addr"
PROTOCOL_FILE_JSON="protocol.json"

POLICY_VKEY_FILE="policy.vkey"
POLICY_SKEY_FILE="policy.skey"

POLICY_SCRIPT_FILE="policy.script"

MATX_RW_FILE="matx.raw"
MATX_SIGNED_FILE="matx.signed"

TX_HASH="cf384045d2aaf2a9f3a201679183eb7d493cecb1543a4ea8dc7f4e63a32f5336"
AMOUNT=1000000000

rm $PROTOCOL_FILE_JSON
rm $POLICY_SKEY_FILE
rm $POLICY_VKEY_FILE
rm $POLICY_SCRIPT_FILE
rm $MATX_RW_FILE
rm $MATX_SIGNED_FILE


cardano-cli  query protocol-parameters \
--testnet-magic 1097911063 \
--out-file $PROTOCOL_FILE_JSON

echo "+++++++++++++++++++++++"
echo $PROTOCOL_FILE_JSON " content:"
cat $PROTOCOL_FILE_JSON
echo "+++++++++++++++++++++++"

cardano-cli address key-gen \
--verification-key-file $POLICY_VKEY_FILE \
--signing-key-file $POLICY_SKEY_FILE

echo "+++++++++++++++++++++++"
echo "Generated Polict Keys on files: " $POLICY_VKEY_FILE " and " $POLICY_SKEY_FILE
echo "+++++++++++++++++++++++"


touch $POLICY_SCRIPT_FILE && echo "" > $POLICY_SCRIPT_FILE

echo "{" >> $POLICY_SCRIPT_FILE
echo "  \"keyHash\": \"$(cardano-cli address key-hash --payment-verification-key-file $POLICY_VKEY_FILE)\"," >> $POLICY_SCRIPT_FILE
echo "  \"type\": \"sig\"" >> $POLICY_SCRIPT_FILE
echo "}" >> $POLICY_SCRIPT_FILE

echo "+++++++++++++++++++++++"
echo $POLICY_SCRIPT_FILE " content:"
cat $POLICY_SCRIPT_FILE
echo "+++++++++++++++++++++++"

POLICY_ID_VALUE=$(cardano-cli transaction policyid --script-file $POLICY_SCRIPT_FILE)

echo "+++++++++++++++++++++++"
echo "Policy ID: " $POLICY_ID_VALUE
echo "+++++++++++++++++++++++"

cardano-cli transaction build-raw \
    --fee 0 \
    --tx-in  $TX_HASH#0 \
    --tx-out $(cat $PAYMENT_ADDR)+0" + 1 $POLICY_ID_VALUE.Elephant + 10 $POLICY_ID_VALUE.Iluvatar" \
    --mint="1 $POLICY_ID_VALUE.Elephant + 10 $POLICY_ID_VALUE.Iluvatar" \
    --out-file $MATX_RW_FILE

FEE=$(cardano-cli transaction calculate-min-fee \
        --tx-body-file $MATX_RW_FILE \
        --tx-in-count 1 \
        --tx-out-count 1 \
        --witness-count 2 \
        --testnet-magic 1097911063 \
        --protocol-params-file $PROTOCOL_FILE_JSON)


echo "+++++++++++++++++++++++"
text=$FEE
IFS=' '
read -a strarr <<< "$text"
FEE=${strarr[0] }
echo "Total fee: " $FEE
echo "+++++++++++++++++++++++"

FINAL_VALUE=`expr $AMOUNT - $FEE`

echo "FINAL_VALUE: " $FINAL_VALUE

cardano-cli transaction build-raw \
    --fee $FEE \
    --tx-in  $TX_HASH#0 \
    --tx-out $(cat $PAYMENT_ADDR)+$FINAL_VALUE" + 1 $POLICY_ID_VALUE.Elephant + 10 $POLICY_ID_VALUE.Iluvatar" \
    --mint="1 $POLICY_ID_VALUE.Elephant + 10 $POLICY_ID_VALUE.Iluvatar" \
    --out-file $MATX_RW_FILE


cardano-cli transaction sign \
    --signing-key-file $PAYMENT_SKEY_FILE \
    --signing-key-file $POLICY_SKEY_FILE \
    --script-file $POLICY_SCRIPT_FILE \
    --testnet-magic 1097911063 \
    --tx-body-file $MATX_RW_FILE \
    --out-file $MATX_SIGNED_FILE

cardano-cli transaction submit --tx-file  $MATX_SIGNED_FILE --testnet-magic 1097911063
