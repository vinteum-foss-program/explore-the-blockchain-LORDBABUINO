# How many new outputs were created by block 123,456?
transactions=$(bitcoin-cli -rpcconnect=84.247.182.145 -rpcuser=user_100 -rpcpassword=QGEExJ6CHJUs getblock $(bitcoin-cli -rpcconnect=84.247.182.145 -rpcuser=user_100 -rpcpassword=QGEExJ6CHJUs getblockhash 123456) | jq -r '.tx[]')

total_count=0
for txid in $transactions; do
  output=$(bitcoin-cli -rpcconnect=84.247.182.145 -rpcuser=user_100 -rpcpassword=QGEExJ6CHJUs getrawtransaction "$txid" true | jq '.vout | length')
  total_count=$((total_count + output))
done

echo $total_count
