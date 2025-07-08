set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Load config
if [ -f "$DIR/config.sh" ]; then
    . "$DIR/config.sh"
else
    echo "Configuration file not found: $DIR/config.sh"
    exit 1
fi

# Load sources
. "$DIR/src/text_info.sh"
. "$DIR/src/text_error.sh"
. "$DIR/src/text_debug.sh"
. "$DIR/src/text_title.sh"
. "$DIR/src/file_delete.sh"
. "$DIR/src/send_report.sh"
. "$DIR/src/analyze.sh"
. "$DIR/src/analyze_lizard.sh"
. "$DIR/src/analyze_phpmetrics.sh"
. "$DIR/src/main.sh"

main "$@"