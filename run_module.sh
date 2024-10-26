#!/bin/bash

# Check if a module name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 {nonrest|rest|evolution|links|taskschedule}"
    exit 1
fi

MODULE=$1
echo "Module specified: $MODULE"

# Define the allowed modules
ALLOWED_MODULES=("nonrest" "rest" "evolution" "links" "taskschedule")

# Check if the provided module is valid
if [[ ! " ${ALLOWED_MODULES[@]} " =~ " ${MODULE} " ]]; then
    echo "Invalid module name. Allowed values are: ${ALLOWED_MODULES[*]}"
    exit 1
fi

# Clean and build the specified module
echo "Building module: $MODULE..."
if ! mvn clean install -pl "$MODULE" -am; then
    echo "Maven build failed for module: $MODULE"
    exit 1
fi

# Run the specified module
echo "Starting module: $MODULE..."

# Navigate to the module directory
cd "$MODULE" || { echo "Failed to change directory to $MODULE."; exit 1; }

# Use a wildcard to find the JAR file
JAR_FILE=$(ls target/"$MODULE"-*.jar 2>/dev/null)

# Check if the JAR file was found
if [ -n "$JAR_FILE" ]; then
    echo "Found JAR file: $JAR_FILE"
    echo "Running $JAR_FILE..."
    if ! java -jar "$JAR_FILE"; then
        echo "Failed to run $JAR_FILE."
        exit 1
    fi
else
    echo "No JAR file found for module $MODULE."
    exit 1
fi
