#!/bin/bash

#==========================================
# Script  : part2.sh
# Purpose : Automated File Deployment
#           Part 2 - Two File Operation
# Author  : Sai Kiran Samadi
# Version : 1.0
#==========================================

set -euo pipefail

#------------------------------------------
# CONFIGURATION
#------------------------------------------
AUTHORIZED_USER="authorized_user"
SOURCE_DIR="/home/source"
TARGET_DIR="/home/target"
SOURCE_FILE_2="sample_file_2.day"
SOURCE_FILE_3="sample_file_3.day"
TARGET_FILE_2="sample_file_2.day"
TARGET_FILE_3="sample_file_3.day"
LOG_DIR="/home/logs/part2"
LOG_FILE="$LOG_DIR/part2_$(date +%Y%m%d_%H%M%S).log"

#------------------------------------------
# CREATE LOG DIRECTORY IF NOT EXISTS
#------------------------------------------
mkdir -p "$LOG_DIR"

#------------------------------------------
# LOGGING FUNCTION
#------------------------------------------
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

#------------------------------------------
# FILE OPERATION FUNCTION
# Reusable function for remove and copy
#------------------------------------------
perform_file_operation() {
    local SOURCE_FILE=$1
    local TARGET_FILE=$2
    local FILE_NUM=$3

    log "------------------------------------------------"
    log "Processing File $FILE_NUM: $SOURCE_FILE"
    log "------------------------------------------------"

    # Source file check
    log "Checking source file $FILE_NUM..."
    if [ ! -f "$SOURCE_DIR/$SOURCE_FILE" ]; then
        log "ERROR: Source file $FILE_NUM not found!"
        log "Path: $SOURCE_DIR/$SOURCE_FILE"
        exit 1
    fi
    log "SUCCESS: Source file $FILE_NUM found!"

    # Target file check and removal
    log "Checking target file $FILE_NUM..."
    if [ ! -f "$TARGET_DIR/$TARGET_FILE" ]; then
        log "WARNING: Target file $FILE_NUM not found!"
        log "Proceeding with copy..."
    else
        log "SUCCESS: Target file $FILE_NUM found!"
        log "Removing target file $FILE_NUM..."
        rm -f "$TARGET_DIR/$TARGET_FILE"
        if [ $? -eq 0 ]; then
            log "SUCCESS: Target file $FILE_NUM removed!"
        else
            log "ERROR: Failed to remove target file $FILE_NUM!"
            exit 1
        fi
    fi

    # Copy file
    log "Copying file $FILE_NUM to target..."
    cp "$SOURCE_DIR/$SOURCE_FILE" "$TARGET_DIR/$TARGET_FILE"
    if [ $? -eq 0 ]; then
        log "SUCCESS: File $FILE_NUM copied successfully!"
        log "From: $SOURCE_DIR/$SOURCE_FILE"
        log "To:   $TARGET_DIR/$TARGET_FILE"
    else
        log "ERROR: File $FILE_NUM copy failed!"
        exit 1
    fi

    # Verification
    log "Verifying file $FILE_NUM placement..."
    if [ -f "$TARGET_DIR/$TARGET_FILE" ]; then
        log "SUCCESS: File $FILE_NUM verified!"
        ls -ltr "$TARGET_DIR/$TARGET_FILE" | tee -a "$LOG_FILE"
    else
        log "ERROR: File $FILE_NUM verification failed!"
        exit 1
    fi
}

#------------------------------------------
# START
#------------------------------------------
log "================================================"
log "Part 2 Deployment Script Started"
log "================================================"

#------------------------------------------
# STEP 1 - USER AUTHORIZATION CHECK
#------------------------------------------
log "Step 1: Checking user authorization..."
CURRENT_USER=$(whoami)

if [ "$CURRENT_USER" != "$AUTHORIZED_USER" ]; then
    log "ERROR: Unauthorized user! Current user: $CURRENT_USER"
    log "ERROR: Only $AUTHORIZED_USER is authorized!"
    log "Script terminated due to unauthorized access!"
    exit 1
fi

log "SUCCESS: User $CURRENT_USER is authorized!"

#------------------------------------------
# STEP 2 - SOURCE DIRECTORY CHECK
#------------------------------------------
log "Step 2: Checking source directory..."

if [ ! -d "$SOURCE_DIR" ]; then
    log "ERROR: Source directory not found: $SOURCE_DIR"
    exit 1
fi

log "SUCCESS: Source directory exists: $SOURCE_DIR"

#------------------------------------------
# STEP 3 - TARGET DIRECTORY CHECK
#------------------------------------------
log "Step 3: Checking target directory..."

if [ ! -d "$TARGET_DIR" ]; then
    log "ERROR: Target directory not found: $TARGET_DIR"
    exit 1
fi

log "SUCCESS: Target directory exists: $TARGET_DIR"

#------------------------------------------
# STEP 4 - PROCESS FILE 2
#------------------------------------------
log "Step 4: Starting File 2 operation..."
perform_file_operation \
    "$SOURCE_FILE_2" \
    "$TARGET_FILE_2" \
    "2"

#------------------------------------------
# STEP 5 - PROCESS FILE 3
#------------------------------------------
log "Step 5: Starting File 3 operation..."
perform_file_operation \
    "$SOURCE_FILE_3" \
    "$TARGET_FILE_3" \
    "3"

#------------------------------------------
# FINAL VERIFICATION
#------------------------------------------
log "Step 6: Final verification of all files..."

if [ -f "$TARGET_DIR/$TARGET_FILE_2" ] && \
   [ -f "$TARGET_DIR/$TARGET_FILE_3" ]; then
    log "SUCCESS: All files verified in target!"
    ls -ltr "$TARGET_DIR/" | tee -a "$LOG_FILE"
else
    log "ERROR: Final verification failed!"
    log "One or more files missing from target!"
    exit 1
fi

#------------------------------------------
# COMPLETION
#------------------------------------------
log "================================================"
log "Part 2 Deployment Completed Successfully!"
log "================================================"

exit 0