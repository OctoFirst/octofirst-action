DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# This file is used only for local testing

GITHUB_SHA=123 \
GITHUB_REF=main \
OCTOFIRST_SECRET=b241f0a647ddfa6a08dd8b958e9c76a0bc38f5a0e9d19205e1 \
GITHUB_REPOSITORY_ID="910722294" \
    bash -x "${DIR}/analyze.sh"