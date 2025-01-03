#!/bin/bash

# Define the Tomcat server URL
TOMCAT_URL="http://ec2-18-223-237-246.us-east-2.compute.amazonaws.com:9090"

# Ensure both arguments (SOURCE_DIR and OUTPUT_DIR) are provided
if [ -z "$1" ]; then
    echo "Error:  TOMCAT_URL must be provided."
    exit 1
fi

# Set the variables from the arguments
TOMCAT_URL="$1"
# Check if Tomcat is running
echo "Checking if Tomcat is running..."
if ps aux | grep -v grep | grep 'tomcat' > /dev/null
then
    echo "Tomcat is running."
else
    echo "Error: Tomcat is not running!"
    exit 1
fi

# Check if the application is deployed and accessible
echo "Checking if the application is accessible at $TOMCAT_URL..."
HTTP_RESPONSE=$(curl --write-out "%{http_code}" --silent --output /dev/null $TOMCAT_URL)
if [ "$HTTP_RESPONSE" -eq 200 ]; then
    echo "Application is successfully deployed and accessible!"
else
    echo "Error: Application is not accessible. HTTP response code: $HTTP_RESPONSE"
    exit 1
fi

# Optional: Check if Tomcat logs contain any errors
echo "Checking Tomcat logs for errors..."
LOG_FILE="/path/to/tomcat/logs/catalina.out"  # Update the path to your Tomcat logs
if grep -i "error" $LOG_FILE > /dev/null
then
    echo "Error: Found errors in the Tomcat logs."
    exit 1
else
    echo "No errors found in Tomcat logs."
fi

# Additional checks can go here...

echo "Sanity check passed successfully!"
