#!/usr/bin/env bash

# Variables
OUTPUT_FILE="./hosts"
if [ -f $OUTPUT_FILE ]; then
  rm $OUTPUT_FILE
fi

# List resources
echo "[all]" >> $OUTPUT_FILE
curl -s -X GET --header 'Accept: application/json' 'http://localhost:3000/api/resources' \
| jq -r '.[] | "\(.name) ansible_host=\(.ip)"' >> $OUTPUT_FILE

# List of group
tags_array=$(curl -s -X GET --header 'Accept: application/json' 'http://localhost:3000/api/tags' \
| jq -r '.[] | "\(.id),\(.name)"')
echo "" >> $OUTPUT_FILE

for tag in $tags_array; do
  awk -F "," {'print "["$2"]"'} <<< $tag >> $OUTPUT_FILE

  tagId=$(awk -F "," {'print $1'} <<< $tag)
  curl -s -X GET --header 'Accept: application/json' "http://localhost:3000/api/tags/${tagId}/resources" \
  | jq -r '.[].name' >> $OUTPUT_FILE
  echo "" >> $OUTPUT_FILE
done

# Print inventory
cat $OUTPUT_FILE
