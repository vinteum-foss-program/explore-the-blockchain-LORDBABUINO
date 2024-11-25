# Which tx in block 257,343 spends the coinbase output of block 256,128?
COINBASE_TXID=$(bitcoin-cli getblock "$(bitcoin-cli getblockhash 256128)" | jq -r '.tx[0]')
TXIDS_IN_BLOCK=$(bitcoin-cli getblock "$(bitcoin-cli getblockhash 257343)" | jq -r '.tx[]')

for TRANSACTION in $TXIDS_IN_BLOCK; do
  IS_SPENDING=$(bitcoin-cli getrawtransaction "$TRANSACTION" true | jq -r --arg COINBASE "$COINBASE_TXID" '.vin[] | select(.txid == $COINBASE)')
  if [ -n "$IS_SPENDING" ]; then
    echo "$TRANSACTION"
    exit 0
  fi
done
