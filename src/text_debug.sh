function text_debug() {
  if [[ "$DEBUG" == "true" ]]; then
    echo -e "\e[36mDEBUG: $1\e[0m"
  fi
}