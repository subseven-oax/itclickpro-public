#!/bin/bash

# Make sure you make this file executable by running `chmod +x Install-Fonts.sh` before running it.
# To run it, use `./Install-Fonts.sh`.

# URL of the ZIP file containing fonts
FONT_ZIP_URL="https://example.com/path/to/fonts.zip"

# Temporary directory to download and extract the ZIP file
TEMP_DIR=$(mktemp -d)

# Download the ZIP file
curl -L -o "$TEMP_DIR/fonts.zip" "$FONT_ZIP_URL"

# Extract the ZIP file
unzip "$TEMP_DIR/fonts.zip" -d "$TEMP_DIR"

# Create the Fonts directory if it doesn't exist
FONT_DIR="$HOME/Library/Fonts"
mkdir -p "$FONT_DIR"

# Move the extracted fonts to the Fonts directory
find "$TEMP_DIR" -name "*.ttf" -or -name "*.otf" -exec mv {} "$FONT_DIR" \;

# Clean up the temporary directory
rm -rf "$TEMP_DIR"

echo "Fonts installed successfully."