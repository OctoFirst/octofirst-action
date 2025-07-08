function text_error() {
  if [[ -z "$1" ]]; then
    echo -e "\e[91mERROR: No message provided\e[0m"
    return 1
  fi
  echo -e "\e[91mERROR: $1\e[0m"
  return 0
}