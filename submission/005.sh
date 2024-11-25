# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`

TX=37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517
INPUTS_ARRAY=$(bitcoin-cli getrawtransaction $TX true | jq -c '.vin[]')

PUBLIC_KEYS_ARRAY=()
for INPUT in $INPUTS_ARRAY; do
  TXINWITNESS=$(echo "$INPUT" | jq -r '.txinwitness[]' | tail -n 1)
  PUBLIC_KEYS_ARRAY+=("$TXINWITNESS")
done

PUBLIC_KEYS_JSON=$(printf '%s\n' "${PUBLIC_KEYS_ARRAY[@]}" | jq -R -s -c 'split("\n")[:-1]')

bitcoin-cli createmultisig 1 "$PUBLIC_KEYS_JSON" | jq -r '.address'
