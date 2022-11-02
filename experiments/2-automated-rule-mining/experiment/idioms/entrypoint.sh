#!/bin/bash


trap "echo 'CTRL-C Pressed. Quiting...'; exit;" SIGINT SIGTERM


rm -f outputs/mined-rules.json
touch outputs/mined-rules.json

echo "Mining rules... (this can be slow)"
# For every new node type created in Phase-III (that is, the SC-* nodes)
for t in $(cat new-node-types-phase-3.txt); do
  # Get everything rooted at $t
  SELECTED_SUBTRESS=$(
    cat gold.jsonl \
    | jq -c ".. | select(.type? == \"${t}\")"
  )

  COUNT=$(
    echo -n "${SELECTED_SUBTRESS}" | wc -l
  )

  if [ "${COUNT}" -ge "50" ]; then
    echo "  + Mining idioms for nodes rooted at \"${t}\":"
    echo -n "${SELECTED_SUBTRESS}" \
      | /home/umd-002677/IdeaProjects/binnacle-icse2020-experiment/experiments/2-automated-rule-mining/experiment/idioms/bin/netcoreapp2.2/linux-x64/idioms \
    >> outputs/mined-rules.json
    echo "    + $(cat outputs/mined-rules.json | wc -l) idiom(s) discovered so far"
  else
    echo "  - Not mining idioms for nodes rooted at \"${t}\": only ${COUNT} < (min-support=50) such trees"
  fi

done
echo "  + Done!"
