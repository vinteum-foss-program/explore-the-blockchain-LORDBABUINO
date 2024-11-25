# How many new outputs were created by block 123,456?
transactions=$(bitcoin-cli getblock "$(bitcoin-cli getblockhash 123456)" | jq -r '.tx[]')

total_count=0
for txid in $transactions; do
  output=$(bitcoin-cli getrawtransaction "$txid" true | jq '.vout | length')
  total_count=$((total_count + output))
done

echo $total_count
