#!/bin/bash

# Ensure both arguments (SOURCE_DIR and OUTPUT_DIR) are provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Error: Both SOURCE_DIR and OUTPUT_DIR must be provided."
    exit 1
fi

# Set the variables from the arguments
SOURCE_DIR="$1"
OUTPUT_DIR="$2"

# Debugging output to verify paths
echo "SOURCE_DIR: $SOURCE_DIR"
echo "OUTPUT_DIR: $OUTPUT_DIR"
echo "POM file path: $SOURCE_DIR/pom.xml"

# Ensure Maven is installed
if ! command -v mvn &>/dev/null; then
    echo "Maven not found, installing..."
    sudo yum install -y maven || sudo apt-get install -y maven
fi

# Check if pom.xml exists at the specified location
if [ ! -f "$SOURCE_DIR/pom.xml" ]; then
    echo "Error: pom.xml not found at $SOURCE_DIR/pom.xml"
    exit 1
fi

# Build the application
echo "Building the application..."

# Run Maven with the correct POM path
mvn clean package -f "$SOURCE_DIR/pom.xml" -DskipTests

# Move the WAR file to the output directory
mkdir -p "$OUTPUT_DIR"
WAR_FILE=$(find "$SOURCE_DIR/helloworld/target" -name "*.war")
if [ -f "$WAR_FILE" ]; then
    mv "$WAR_FILE" "$OUTPUT_DIR/"
    echo "Build successful. WAR file located at: $OUTPUT_DIR/$(basename "$WAR_FILE")"
else
    echo "Build failed. No WAR file found."
    exit 1
fi
