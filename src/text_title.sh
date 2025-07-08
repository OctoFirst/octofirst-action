function text_title {
    if [ -z "$1" ]; then
        echo "Usage: text_title <message>"
        return 1
    fi

    echo ""
    echo -e "\033[1;4m$1\033[0m"
}