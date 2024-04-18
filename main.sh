#!/bin/bash

instagram_id="17841465696847893"
access_token="EAALWR0fZB1UEBO2rVlSQu9PfHwHBN9FG3dXl1pUZCVuQ0vOS4xcMn85l367WEFZCFQbQBmggP6DakGeg0Xm2hndxzXzwwKeyY5Q4R30gwUMZCN4ZA7ZCuTJk1xLPeIwTqkKUBTu75eNPr50qeX6qKkoGQeNAoNIMUSYr6mHaG7AJqo81lJKrm6FzumwDQhMPrWiwZDZD"
caption=$(cat "caption.txt")

function start(){
local count=$1
image_url="https://raw.githubusercontent.com/ExtremeKrish/Auto-IG/main/imggen_${count}.png"

# Calling the first API
id=$(call_first_api "${image_url}" "${access_token}")

if [ -n "${id}" ]; then
response=$(call_second_api "${id}" "${access_token}")
echo "."
echo "."
echo "."
echo "Post Uploaded 🎉"
echo "Post Number: ${count}"
else
echo "Error: Failed to get ID from the first API call."
fi
}

function call_first_api() {
    local image_url="$1"
    local access_token="$2"

	
    encoded_caption=$(urlencode_multiline "${caption}")
    
    # Making the curl POST request and parsing JSON response with jq
    response=$(curl -s -X POST \
    "https://graph.facebook.com/v19.0/${instagram_id}/media?image_url=${image_url}&access_token=${access_token}&caption=${encoded_caption}")
	
    # Extracting the ID from the response using jq
    id=$(echo "${response}" | jq -r '.id')

    echo "${id}"
}

function call_second_api() {
    local creation_id="$1"
    local access_token="$2"

    # Making the curl POST request
    response=$(curl -s -X POST \
    "https://graph.facebook.com/v19.0/${instagram_id}/media_publish?creation_id=${creation_id}&access_token=${access_token}")

    echo "${response}"
}

urlencode_multiline() {
    # URL-encode the input text while preserving line breaks
    encoded=$(echo -n "$1" | jq -sRr @uri)
    
    echo "$encoded"
}




for ((i=7; i<=74; i++)); do
    start "$i"  # Calling start function with current count
    echo "."
    echo "Next Post in 2 hours...."
    sleep 7200  # Sleep for 2 hours (4 hours * 60 minutes * 60 seconds = 14400 seconds)
done
