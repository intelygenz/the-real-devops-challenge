#!/bin/bash

# Change directory to aws-modules
cd "aws-modules" || { echo "Directory not found"; exit 1; }
chmod +x generate-docs.sh

# Run generate-docs.sh
./generate-docs.sh

# Return to challenge-3 directory
cd ../ || { echo "Directory not found"; exit 1; }

terraform-docs markdown table --output-file README.md --output-mode inject ./
