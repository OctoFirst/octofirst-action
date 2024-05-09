set -e

# Install lizard
pip install lizard

# Start the analysis
lizard --output_file=lizard.csv
