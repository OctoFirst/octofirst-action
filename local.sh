DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# This file is used only for local testing

GITHUB_SHA=123 \
GITHUB_REF=main \
OCTOFIRST_SECRET=123secret \
GITHUB_REPOSITORY_ID="123456" \
    bash "${DIR}/analyze.sh"