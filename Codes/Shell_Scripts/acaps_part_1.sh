#!/bin/bash

#==========================================
# Script  : part1.sh
# Purpose : Automated File Deployment
#           Part 1 - Single File Operation
# Author  : Sai Kiran Samadi
# Version : 1.0
#==========================================
#set -x
set -euo pipefail

#------------------------------------------
# CONFIGURATION
#------------------------------------------
AUTHORIZED_USER="CTS+2320404"
BASE_DIR="/c/Users/2320404/OneDrive - Cognizant/documents/github/data_engineer/codes/shell_scripts"
SOURCE_DIR="$BASE_DIR/source"
TARGET_DIR="$BASE_DIR/target"
SOURCE_FILE="sample_file_1.day"
TARGET_FILE="sample_file_1.day"
LOG_DIR="$BASE_DIR/logs/part_1"
LOG_FILE="$LOG_DIR/part_1_$(date +%Y%m%d_%H%M%S).log"

#------------------------------------------
# CREATE LOG DIRECTORY IF NOT EXISTS
#------------------------------------------
mkdir -p "$LOG_DIR"

#------------------------------------------
# LOGGING FUNCTION
#------------------------------------------

#Function to log messages to log file

log_file() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S') IST] $1" >> "$LOG_FILE"
}

#Function to log messages to both console and log file
log_screen() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S') IST] $1" | tee -a "$LOG_FILE"
}

#------------------------------------------
# START
#------------------------------------------
log_screen "================================================"
log_screen "Part 1 Deployment Script Started"
log_screen "================================================"

#------------------------------------------
# STEP 1 - USER AUTHORIZATION CHECK
#------------------------------------------
log_file "Step 1: Checking user authorization..."
CURRENT_USER=$(whoami)

if [ "$CURRENT_USER" != "$AUTHORIZED_USER" ]; then
    log_screen "ERROR: Unauthorized user! Current user: $CURRENT_USER"
    log_screen "ERROR: Only $AUTHORIZED_USER is authorized to run this script!"
    log_file "Script terminated due to unauthorized access!"
    exit 1
fi

log_file "SUCCESS: User $CURRENT_USER is authorized to proceed!"

#------------------------------------------
# STEP 2 - SOURCE DIRECTORY CHECK
#------------------------------------------
log_file "Step 2: Checking source directory..."

if [ ! -d "$SOURCE_DIR" ]; then
    log_screen "ERROR: Source directory not found: $SOURCE_DIR"
    log_file "Script terminated!"
    exit 1
fi

log_file "SUCCESS: Source directory exists: $SOURCE_DIR"

#------------------------------------------
# STEP 3 - SOURCE FILE CHECK
#------------------------------------------
log_file "Step 3: Checking source file..."

if [ ! -f "$SOURCE_DIR/$SOURCE_FILE" ]; then
    log_screen "ERROR: Source file not found: $SOURCE_DIR/$SOURCE_FILE"
    log_file "Script terminated!"
    exit 1
fi

log_file "SUCCESS: Source file exists: $SOURCE_DIR/$SOURCE_FILE"

#------------------------------------------
# STEP 4 - TARGET DIRECTORY CHECK
#------------------------------------------
log_file "Step 4: Checking target directory..."

if [ ! -d "$TARGET_DIR" ]; then
    log_screen "ERROR: Target directory not found: $TARGET_DIR"
    log_file "Script terminated!"
    exit 1
fi

log_file "SUCCESS: Target directory exists: $TARGET_DIR"

#------------------------------------------
# STEP 5 - TARGET FILE CHECK AND REMOVAL
#------------------------------------------
log_file "Step 5: Checking target file before removal..."

if [ ! -f "$TARGET_DIR/$TARGET_FILE" ]; then
    log_screen "WARNING: Target file not found: $TARGET_DIR/$TARGET_FILE"
    log_screen "File may have already been removed or never existed!"
    log_screen "Proceeding with copy operation..."
else
    log_file "SUCCESS: Target file found: $TARGET_DIR/$TARGET_FILE"
    log_screen "Proceeding to remove $TARGET_FILE file..."

    rm -f "$TARGET_DIR/$TARGET_FILE"

    if [ $? -eq 0 ]; then
        log_screen "SUCCESS: $TARGET_FILE file removed successfully!"
    else
        log_screen "ERROR: Failed to remove $TARGET_FILE file!"
        log_file "Script terminated!"
        exit 1
    fi
fi

#------------------------------------------
# STEP 6 - COPY FILE FROM SOURCE TO TARGET
#------------------------------------------
log_file "Step 6: Copying file from source to target..."

cp "$SOURCE_DIR/$SOURCE_FILE" "$TARGET_DIR/$TARGET_FILE"

if [ $? -eq 0 ]; then
    log_screen "SUCCESS: $SOURCE_FILE File copied successfully!"
    log_file "From: $SOURCE_DIR/$SOURCE_FILE"
    log_file "To:   $TARGET_DIR/$TARGET_FILE"
else
    log_screen "ERROR: $SOURCE_FILE copy failed!"
    log_file "Script terminated!"
    exit 1
fi

#------------------------------------------
# STEP 7 - POST COPY VERIFICATION
#------------------------------------------
log_file "Step 7: Verifying file placement..."

if [ -f "$TARGET_DIR/$TARGET_FILE" ]; then
    log_screen "SUCCESS: $TARGET_FILE File verified successfully after copy!"
    log_file "SUCCESS: $TARGET_FILE File verified in $TARGET_DIR location!"
    log_file "File: $TARGET_DIR/$TARGET_FILE"
    ls -ltr "$TARGET_DIR/$TARGET_FILE" >> "$LOG_FILE"
else
    log_screen "ERROR: $TARGET_FILE File verification failed!"
    log_screen "$TARGET_FILE File not found in $TARGET_DIR after copy!"
    log_file "Script terminated!"
    exit 1
fi

#------------------------------------------
# COMPLETION
#------------------------------------------
log_screen "================================================"
log_screen "Part 1 Deployment Completed Successfully!"
log_screen "================================================"

#------------------------------------------
# For More Details Check Log File
#------------------------------------------

log_screen "For more details, check the log file: $LOG_FILE"

exit 0