#!/bin/bash

# Script to remove Pods_Runner.framework references from Xcode project
# This fixes the "Framework 'Pods_Runner' not found" error

PROJECT_FILE="Runner.xcodeproj/project.pbxproj"

echo "Removing Pods_Runner.framework references from $PROJECT_FILE..."

# Create a backup
cp "$PROJECT_FILE" "$PROJECT_FILE.backup"

# Remove the three types of Pods_Runner.framework references:
# 1. PBXBuildFile reference (in Build Phases)
# 2. PBXFileReference (file reference)
# 3. Reference in PBXFrameworksBuildPhase
# 4. Reference in Frameworks group

# Use sed to remove lines containing Pods_Runner.framework
sed -i '' '/Pods_Runner\.framework/d' "$PROJECT_FILE"

echo "Done! Pods_Runner.framework references have been removed."
echo "Backup saved as $PROJECT_FILE.backup"
