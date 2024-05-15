set -e


function analyze {

    # if env == "dev" then
    url="@todo"
    # If $GITHUB_ACTIONS is not set, then we are running locally
    if [ -z "$GITHUB_ACTIONS" ]; then
        echo "Running in dev mode"
        url="http://localhost:8000/webhook/github/action/_ACTION_?"
    fi

    RUN="${GITHUB_RUN_ID}"
    if [ -z "$RUN" ]; then
        RUN="local"
    fi

    # ensure variables are set
    if [ -z "$GITHUB_SHA" ]; then
        echo "GITHUB_SHA is not set"
        exit 1
    fi

    if [ -z "$GITHUB_REF" ]; then
        echo "GITHUB_REF is not set"
        exit 1
    fi

    if [ -z "$GITHUB_REPOSITORY" ]; then
        echo "GITHUB_REPOSITORY is not set"
        exit 1
    fi

    if [ -z "$GITHUB_REPOSITORY_ID" ]; then
        echo "GITHUB_REPOSITORY_ID is not set"
        exit 1
    fi

    # add current git commit hash to the url
    url="$url&ref=${GIT_SHA}"

    # add current branch
    url="$url&branch=${GITHUB_REF}"

    # add current repository
    url="$url&repository=${GITHUB_REPOSITORY}"
    url="$url&repository_id=${GITHUB_REPOSITORY_ID}"

    # add date
    date=$(echo $GIT_DATE | sed 's/ /%20/g')
    url="$url&date=${date}"

    analyze_lizard
}

function analyze_lizard {

    echo "Analyzing with lizard"

    # Install lizard
    installed=$(pip show lizard)
    if [ -z "$installed" ]; then
        echo "Installing lizard"
        pip install lizard
    fi

    # Start the analysis
    lizard \
        --output_file=lizard.csv \
        --exclude "**/node_modules/*" \
        --exclude "**/vendor/*" \
        --exclude "**/Resources/*" \
        --exclude "**/.idea/*" \
        --exclude "**/.github/*" \
        --exclude "**/var/*" \
        --exclude "**/config/*" \
        --exclude "**/log/*" \
        --exclude "**/logs/*" \
        --exclude "**/cache/*" \
        -V

    # Send the results to the server
    lizardUrl=$(echo $url|sed 's/_ACTION_/lizard/g')
    echo "Sending lizard results to $lizardUrl"
    response=$(curl \
        -X POST $lizardUrl \
        --fail \
        --insecure \
        -L \
        -H "Content-Type: text/csv" \
        --data-binary @lizard.csv)

    echo "Response: $response"

    rm lizard.csv
}

analyseHistory=false
# detect if last commit concerns the .github/workflows/ast-pulse.yml file
# (it means that the analysis is triggered for the first time or the configuration has changed)
last_commit=$(git log -1 --name-only --pretty=format:"%H")
if git diff-tree --no-commit-id --name-only -r $last_commit | grep -q ".github/workflows/ast-pulse.yml"; then
    echo "Last commit concerns the .github/workflows/ast-pulse.yml file"
    analyseHistory=true
fi

# If the last commit concerns the .github/workflows/ast-pulse.yml file, then we need to analyze the history, week by week
if [ "$analyseHistory" = true ]; then
    echo "Analyzing history"
    currentBranch=$(git branch --show-current)

    # Get one commit per week, 4 weeks back
    for i in {0..4}
    do
        echo "Analyzing week $i"
        git checkout $currentBranch

        # Get the first commit 7 days ago
        commit=$(git rev-list -n 1 --before="$(date -d "$i weeks ago" --iso-8601=seconds)" $currentBranch)
        if [ -z "$commit" ]; then
            echo "No commit found for date $(date -d "$i weeks ago" --iso-8601=seconds)"
            continue
        fi

        git checkout $commit

        # get timestamp of the commit
        GIT_DATE=$(git show -s --format=%ci)
        GIT_SHA=$(git rev-parse HEAD)

        # Execute the analysis
        analyze
    done

    git checkout $currentBranch
else
    # Analyze the current commit only
    echo "Analyzing current commit"
    GIT_DATE=$(git show -s --format=%ci)
    analyze
fi

echo "Done"