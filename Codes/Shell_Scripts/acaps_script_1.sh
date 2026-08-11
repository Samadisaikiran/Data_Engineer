#!/bin/bash  
set -euo pipefail  

# Initialize log directory and log file  
LOG_DIR="./logs"  
LOG_FILE="$LOG_DIR/script.log"  
mkdir -p "$LOG_DIR"  
echo "Log initialized at $(date)" > "$LOG_FILE"  

# Function to log messages  
log_message() {  
	local message="$1"  
	echo "$(date): $message" | tee -a "$LOG_FILE"  
}  

# User validation  
log_message "Starting user validation..."  
if [[ "$EUID" -ne 0 ]]; then  
	log_message "Error: This script must be run as root."  
	exit 1  
fi  
log_message "User validation successful."  

# Source and target directory validation
SOURCE_DIR=""  
TARGET_DIR=""  
log_message "Validating source and target directories..."  
read -p "Enter the source directory: " SOURCE_DIR  
read -p "Enter the target directory: " TARGET_DIR  

if [[ ! -d "$SOURCE_DIR" ]]; then  
	log_message "Error: Source directory '$SOURCE_DIR' does not exist."  
	exit 1  
fi  

if [[ ! -d "$TARGET_DIR" ]]; then  
	log_message "Error: Target directory '$TARGET_DIR' does not exist."  
	exit 1  
fi  
log_message "Source and target directories validated successfully."  

# File copy operation  
FILE_TO_COPY=""  
read -p "Enter the name of the file to copy (from source directory): " FILE_TO_COPY  

if [[ ! -f "$SOURCE_DIR/$FILE_TO_COPY" ]]; then  
	log_message "Error: File '$FILE_TO_COPY' does not exist in source directory."  
	exit 1  
fi  

log_message "Copying file '$FILE_TO_COPY' from '$SOURCE_DIR' to '$TARGET_DIR'..."  
cp "$SOURCE_DIR/$FILE_TO_COPY" "$TARGET_DIR"  
log_message "File copied successfully."  

# Validate copied file  
log_message "Validating copied file in target directory..."  
if [[ -f "$TARGET_DIR/$FILE_TO_COPY" ]]; then  
	log_message "Validation successful: File '$FILE_TO_COPY' exists in target directory."  
else  
	log_message "Error: File '$FILE_TO_COPY' does not exist in target directory after copy."  
	exit 1  
fi  

# Final message  
log_message "Script execution completed successfully."  
echo "All operations completed successfully. Check the log file at '$LOG_FILE' for details."  