function analyze_phpmetrics {

    text_title "Analyzing with PhpMetrics"

    if [ "$SKIP_PHPMETRICS" = true ]; then
        text_info "Skipping PhpMetrics analysis"
        return 0
    fi

    # Install lizard
    installed=$(which phpmetrics)
    if [ -z "$installed" ]; then
        text_error "Please install phpmetrics first"
        exit 1
    fi

    # Start the analysis
    phpmetrics \
        --exclude="node_modules,vendor,Resources,.idea,.github,var,config,log,logs,cache" \
        --report-summary-json=phpmetrics-summary.json \
        .

    # Send the results to the server
    send_report "phpmetrics" "phpmetrics-summary.json"
    file_delete "phpmetrics-summary.json"
}