#!/bin/bash

# Default values for arguments
SOURCE_DIR="./"
OUTPUT_DIR="./build"

# Parse arguments for custom source and output directories
while getopts s:o: flag; do
    case "${flag}" in
        s) SOURCE_DIR=${OPTARG};;
        o) OUTPUT_DIR=${OPTARG};;
    esac
done

# Ensure Maven is installed
if ! command -v mvn &>/dev/null; then
    echo "Maven not found, installing..."
    sudo yum install -y maven || sudo apt-get install -y maven
fi

# Build the application
echo "Building the application..."
mvn -f "$SOURCE_DIR/pom.xml" clean package -DskipTests

# Move the WAR file to the output directory
mkdir -p "$OUTPUT_DIR"
WAR_FILE=$(find "$SOURCE_DIR/target" -name "*.war")
if [ -f "$WAR_FILE" ]; then
    mv "$WAR_FILE" "$OUTPUT_DIR/"
    echo "Build successful. WAR file located at: $OUTPUT_DIR/$(basename "$WAR_FILE")"
else
    echo "Build failed. No WAR file found."
    exit 1
fi
