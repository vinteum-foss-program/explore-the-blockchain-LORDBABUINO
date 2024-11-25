# Only one single output remains unspent from block 123,321. What address was it sent to?

bitcoin-cli getblock "$(bitcoin-cli getblockhash 123321)" | jq -r '.tx[]' | while read -r TXID; do
  bitcoin-cli getrawtransaction "$TXID" true | jq -c '.vout[]' | while read -r VOUT; do
    bitcoin-cli gettxout "$TXID" "$(echo "$VOUT" | jq -r '.n')" | jq -r '.scriptPubKey.address'
    exit 0
  done
done
