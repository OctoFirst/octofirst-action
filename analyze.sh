set -e

# if env == "dev" then
url="@todo"
if [ "$ENV" == "dev" ]; then
    echo "Running in dev mode"
    url="http://localhost:8000/webhook/github/action/lizard?"
fi

# add current git commit hash to the url
url="$url&ref=$(git rev-parse HEAD)"

# add current branch
url="$url&branch=$(git rev-parse --abbrev-ref HEAD)"

# add current repo
url="$url&repo=$(git config --get remote.origin.url)"

echo "URL: $url"


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
    --exclude "**/var/*" \
    --exclude "**/cache/*" \
    --csv \

# Send the results to the server
response=$(curl \
    -X POST $url \
    --fail \
    --insecure \
    -L \
    -H "Content-Type: text/csv" \
    --data-binary @lizard.csv)

echo "Response: $response"