function analyze_lizard {

    text_title "Analyzing with lizard"

    if [ "true" == "$SKIP_LIZARD" ]; then
        text_info "Skipping lizard analysis"
        return 0
    fi

    # Install lizard
    installed=$(pip show lizard||which lizard)
    if [ -z "$installed" ]; then
        text_error "Please install lizard: pip install lizard"
        exit 1
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
    send_report "lizard" "lizard.csv" "text/csv"
    file_delete lizard.csv
}