#!/bin/bash

# Navigate to the aws-modules directory
cd "$(dirname "$0")"

# Loop through each subdirectory
for dir in */; do
    if [ -d "$dir" ]; then
        echo "Processing directory: $dir"
        cd "$dir"
        # Run terraform-docs command
        terraform-docs markdown table --output-file README.md --output-mode inject ./
        cd ..
    fi
done