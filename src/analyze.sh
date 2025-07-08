
function analyze {

    if [ -z "$GITHUB_REPOSITORY_ID" ]; then
        text_error "GITHUB_REPOSITORY_ID is not set"
        exit 1
    fi

    if [ -z "$OCTOFIRST_SECRET" ]; then
        text_error "OCTOFIRST_SECRET is not set"
        exit 1
    fi

    if [ -z "$GITHUB_REF" ]; then
        text_error "GITHUB_REF is not set"
        exit 1
    fi

    # ensure variables are set
    if [ -z "$GITHUB_SHA" ]; then
        text_error "GITHUB_SHA is not set"
        exit 1
    fi


    # if env == "dev" then
    url="https://app.octofirst.com"
    # If $GITHUB_ACTIONS is not set, then we are running locally
    if [ -z "$GITHUB_ACTIONS" ]; then
        text_info "Running in dev mode"
        url="http://localhost:8000"
    fi


    url="${url}/webhook/github/r/${GITHUB_REPOSITORY_ID}/action/_ACTION_?key=${OCTOFIRST_SECRET}&branch=${GITHUB_REF}&sha=${GITHUB_SHA}"

    # add date
    date=$(echo $GIT_DATE | sed 's/ /%20/g')
    date=$(echo $date | sed 's/+/%2B/g')
    date=$(echo $date | sed 's/:/%3A/g')
    date=$(echo $date | sed 's/-/%2D/g')
    url="$url&date=${date}"

    analyze_lizard
    analyze_phpmetrics
}