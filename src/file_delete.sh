function file_delete() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    text_error "File not found: $file"
    return 1
  fi

  text_info "Cleaning file: $file"
  if [[ "true" == "$PRESERVE_FILES" ]]; then
    text_info "Preserve file option is enabled, skipping removal of: $file"
    return 0
  fi

  rm "$file"
}