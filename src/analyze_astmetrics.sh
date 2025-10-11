function analyze_astmetrics() {

    text_title "Analyzing with AST Metrics"

    if [ "true" == "$SKIP_ASTMETRICS" ]; then
        text_info "Skipping ast-metrics analysis"
        return 0
    fi

    # Install ast-metrics
    curl -s https://raw.githubusercontent.com/Halleck45/ast-metrics/main/scripts/download.sh|bash

    # Start the analysis
    ./ast-metrics ci .

    # Send the results to the server
    send_report "ast-metrics" "ast-metrics-report.json" "application/json"
    file_delete "ast-metrics-report.json"
}