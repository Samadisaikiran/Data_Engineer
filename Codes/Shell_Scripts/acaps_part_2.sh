#!/bin/bash
START_TIME=$(date +%s)
#==========================================
# Script  : part2.sh
# Purpose : Automated File Deployment
#           Part 2 - Two File Operation
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
SOURCE_FILE_2="sample_file_2.day"
SOURCE_FILE_3="sample_file_3.day"
TARGET_FILE_2="sample_file_2.day"
TARGET_FILE_3="sample_file_3.day"
LOG_DIR="$BASE_DIR/logs/part_2"
LOG_FILE="$LOG_DIR/part_2_$(date +%Y%m%d_%H%M%S).log"

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
# FILE OPERATION FUNCTION
# Reusable function for remove and copy
#------------------------------------------
perform_file_operation() {
    local SOURCE_FILE=$1
    local TARGET_FILE=$2
    local FILE_NUM=$3

    log_file "------------------------------------------------"
    log_file "Processing File $FILE_NUM: $SOURCE_FILE"
    log_file "------------------------------------------------"

    # Source file check
    log_file "Checking source file $FILE_NUM..."
    if [ ! -f "$SOURCE_DIR/$SOURCE_FILE" ]; then
        log_screen "ERROR: $SOURCE_FILE file not found!"
        log_file "ERROR: Source $SOURCE_FILE file $FILE_NUM not found!"
        log_file "Path: $SOURCE_DIR/$SOURCE_FILE"
        exit 1
    fi
    log_screen "SUCCESS: $SOURCE_FILE file found!"
    log_file "SUCCESS: Source $SOURCE_FILE file $FILE_NUM found!"

    # Target file check and removal
    log_file "Checking target file $FILE_NUM..."
    if [ ! -f "$TARGET_DIR/$TARGET_FILE" ]; then
        log_screen "WARNING: Target $TARGET_FILE file not found!"
        log_file "WARNING: Target $TARGET_FILE file $FILE_NUM not found!"
        log_screen "Proceeding with copy..."
    else
        log_file "SUCCESS: $TARGET_FILE file found!"
        log_file "SUCCESS: Target $TARGET_FILE file $FILE_NUM found!"
        log_file "Removing $TARGET_FILE file $FILE_NUM..."
        log_screen "Proceeding to remove $TARGET_FILE file..."
        rm -f "$TARGET_DIR/$TARGET_FILE"
        if [ $? -eq 0 ]; then
            log_screen "SUCCESS: $TARGET_FILE file removed!"
        else
            log_screen "ERROR: Failed to remove $TARGET_FILE file!"
            exit 1
        fi
    fi

    # Copy file
    log_file "Copying $SOURCE_FILE file to target..."
    cp "$SOURCE_DIR/$SOURCE_FILE" "$TARGET_DIR/$TARGET_FILE"
    if [ $? -eq 0 ]; then
        log_screen "SUCCESS: $SOURCE_FILE copied successfully!"
        log_file "From: $SOURCE_DIR/$SOURCE_FILE"
        log_file "To:   $TARGET_DIR/$TARGET_FILE"
    else
        log_screen "ERROR: $SOURCE_FILE file copy failed!"
        exit 1
    fi

    # Verification
    log_file "Verifying file $TARGET_FILE placement..."
    if [ -f "$TARGET_DIR/$TARGET_FILE" ]; then
        log_screen "SUCCESS: $TARGET_FILE File verified successfully after copy!"
        ls -ltr "$TARGET_DIR/$TARGET_FILE" >> "$LOG_FILE"
    else
        log_screen "ERROR: $TARGET_FILE File verification failed!"
        exit 1
    fi
}

#------------------------------------------
# START
#------------------------------------------
log_screen "================================================"
log_screen "Part 2 Deployment Script Started"
log_screen "================================================"

#------------------------------------------
# STEP 1 - USER AUTHORIZATION CHECK
#------------------------------------------
log_file "Step 1: Checking user authorization..."
CURRENT_USER=$(whoami)

if [ "$CURRENT_USER" != "$AUTHORIZED_USER" ]; then
    log_screen "ERROR: Unauthorized user! Current user: $CURRENT_USER"
    log_screen "ERROR: Only $AUTHORIZED_USER is authorized!"
    log_file "Script terminated due to unauthorized access!"
    exit 1
fi

log_file "SUCCESS: User $CURRENT_USER is authorized!"

#------------------------------------------
# STEP 2 - SOURCE DIRECTORY CHECK
#------------------------------------------
log_file "Step 2: Checking source directory..."

if [ ! -d "$SOURCE_DIR" ]; then
    log_screen "ERROR: Source directory not found: $SOURCE_DIR"
    exit 1
fi

log_file "SUCCESS: Source directory exists: $SOURCE_DIR"

#------------------------------------------
# STEP 3 - TARGET DIRECTORY CHECK
#------------------------------------------
log_file "Step 3: Checking target directory..."

if [ ! -d "$TARGET_DIR" ]; then
    log_screen "ERROR: Target directory not found: $TARGET_DIR"
    exit 1
fi

log_file "SUCCESS: Target directory exists: $TARGET_DIR"

#------------------------------------------
# STEP 4 - PROCESS FILE 2
#------------------------------------------
log_file "Step 4: Starting File 2 operation..."
perform_file_operation \
    "$SOURCE_FILE_2" \
    "$TARGET_FILE_2" \
    "2"
log_screen "....."
#------------------------------------------
# STEP 5 - PROCESS FILE 3
#------------------------------------------
log_file "Step 5: Starting File 3 operation..."
perform_file_operation \
    "$SOURCE_FILE_3" \
    "$TARGET_FILE_3" \
    "3"

#------------------------------------------
# FINAL VERIFICATION
#------------------------------------------
log_file "Step 6: Final verification of all files..."

if [ -f "$TARGET_DIR/$TARGET_FILE_2" ] && \
   [ -f "$TARGET_DIR/$TARGET_FILE_3" ]; then
    log_screen "....."
    log_screen "SUCCESS: All files verified Successfully!"
#   ls -ltr "$TARGET_DIR/" | tee -a "$LOG_FILE"
    ls -ltr "$TARGET_DIR/" >> "$LOG_FILE"
else
    log_screen "ERROR: Files verification failed!"
    log_screen "One or more files missing from target!"
    exit 1
fi

#------------------------------------------
# COMPLETION
#------------------------------------------
log_screen "================================================"
log_screen "Part 2 Deployment Completed Successfully!"
log_screen "================================================"

#------------------------------------------
# For More Details Check Log File
#------------------------------------------
log_file "For more details, check the log file: $LOG_FILE"
echo "For more details, check the log file: $LOG_FILE"

#------------------------------------------
## Execution Time Calculation
#------------------------------------------
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
echo "Total execution time: ${DURATION} seconds"

exit 0