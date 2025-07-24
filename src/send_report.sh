function send_report {
  name="$1"
  file="$2"
  contentType="$3"

  if [[ "true" == "$SKIP_REPORT" ]]; then
    text_info "Skipping report sending as SKIP_REPORT is set to true."
    return 0
  fi


  if [ -z "$name" ] || [ -z "$file" ]; then
    text_error "Usage: send_report <name> <file> <contentType>"
    exit 1
  fi

  finalUrl=$(echo $url|sed "s/_ACTION_/$name/g")
  text_info "Sending $name results to $finalUrl"
  response=$(curl \
      -X POST $finalUrl \
      --fail \
      -L \
      -H "Content-Type: $contentType" \
      --data-binary @$file \
  )

  text_info "Response: $response"
}