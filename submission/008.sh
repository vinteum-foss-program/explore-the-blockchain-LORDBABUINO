# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
TXID=e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163
WITNESS_SCRIPT=$(bitcoin-cli getrawtransaction "$TXID" true | jq -r '.vin[0].txinwitness[-1]')

PUBKEYS=()
while [ -n "$WITNESS_SCRIPT" ]; do
  LENGTH_HEX=${WITNESS_SCRIPT:0:2}
  LENGTH_DEC=$((16#$LENGTH_HEX))

  if [ "$LENGTH_DEC" -gt 75 ]; then
    WITNESS_SCRIPT=${WITNESS_SCRIPT:2} # Move to the next byte
    continue
  fi

  ELEMENT=${WITNESS_SCRIPT:2:$((LENGTH_DEC * 2))}

  WITNESS_SCRIPT=${WITNESS_SCRIPT:$((2 + LENGTH_DEC * 2))}

  if [[ "$ELEMENT" =~ ^02|^03 ]]; then
    PUBKEYS+=("$ELEMENT")
  fi
done

echo "${PUBKEYS[0]}"
