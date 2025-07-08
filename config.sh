# Do not send the report to the server
if [[ -z "$SKIP_REPORT" ]]; then
  SKIP_REPORT=false
fi

# Do not delete the files after analysis
if [[ -z "$PRESERVE_FILES" ]]; then
  PRESERVE_FILES=false
fi

# Do not run lizard analysis
if [[ -z "$SKIP_LIZARD" ]]; then
  SKIP_LIZARD=false
fi

# Do not run phpmetrics analysis
if [[ -z "$SKIP_PHPMETRICS" ]]; then
  SKIP_PHPMETRICS=true
fi