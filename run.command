#!/bin/bash

echo "Running Love2D project..."

# Path to the Love2D application executable
LOVE_APP="/Applications/love.app/Contents/MacOS/love"

echo "Love2D App Path: $LOVE_APP"

# Path to your Love2D project folder
# Replace /Path/to/Love/Project/File/ with the actual path to your project folder
PROJECT_PATH="/Users/ManuSanchez/Desktop/lua-platformer2d"

echo "Project Path: $PROJECT_PATH"

# Running the Love2D project
$LOVE_APP "$PROJECT_PATH"

# chmod 755 run.command
