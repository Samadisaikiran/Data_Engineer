#!/usr/bin/env python3

#==========================================
# Script  : email_reader.py
# Purpose : Read Gmail and detect
#           ACAPS trigger email
#           then trigger master.sh
# Author  : Sai Kiran Samadi
# Version : 2.0
#==========================================

import imaplib
import email
import ssl
import subprocess
import time
import sys
from email.header import decode_header

#------------------------------------------
# CONFIGURATION
#------------------------------------------
EMAIL_ADDRESS   = "your gmail@gmail.com"
APP_PASSWORD    = "gmail 16 charcters password"
IMAP_SERVER     = "imap.gmail.com"
TRIGGER_SUBJECT = "ACAPS Data Load Complete"
BASH_PATH       = "C:/Program Files/Git/bin/bash.exe"
MASTER_SCRIPT   = "C:/Users/2320404/OneDrive - Cognizant/documents/github/data_engineer/codes/shell_scripts/master.sh"
CHECK_INTERVAL  = 10
MAX_RETRIES     = 3

#------------------------------------------
# LOGGING FUNCTION
#------------------------------------------
def log(message):
    timestamp = time.strftime('%Y-%m-%d %H:%M:%S')
    print(f"[{timestamp} IST] {message}", flush=True)

#------------------------------------------
# CONNECT TO GMAIL
#------------------------------------------
def connect_to_gmail():
    attempt = 0
    while attempt < MAX_RETRIES:
        try:
            log("Connecting to Gmail...")
            context = ssl.create_default_context()
            mail = imaplib.IMAP4_SSL(
                IMAP_SERVER,
                993,
                ssl_context=context
            )
            mail.login(EMAIL_ADDRESS, APP_PASSWORD)
            log("Connected to Gmail successfully!")
            return mail
        except imaplib.IMAP4.error as e:
            log(f"Login failed: {e}")
            log("Check email and app password!")
            return None
        except Exception as e:
            attempt += 1
            log(f"Connection attempt {attempt} failed: {e}")
            if attempt < MAX_RETRIES:
                log(f"Retrying in 30 seconds...")
                time.sleep(30)
            else:
                log("Max retries reached!")
                return None

#------------------------------------------
# CHECK FOR TRIGGER EMAIL
#------------------------------------------
def check_for_trigger_email(mail):
    try:
        # Select inbox
        mail.select("inbox")

        # Search unread emails only
        status, messages = mail.search(None, 'UNSEEN')

        if not messages[0]:
            log("No new emails found!")
            return False

        # Loop through unread emails
        for msg_id in messages[0].split():

            # Fetch email
            status, msg_data = mail.fetch(msg_id, "(RFC822)")
            msg = email.message_from_bytes(msg_data[0][1])

            # Get subject
            subject = decode_header(msg["Subject"])[0][0]
            if isinstance(subject, bytes):
                subject = subject.decode()

            # Get sender
            sender = msg["From"]

            log(f"New email found!")
            log(f"From:    {sender}")
            log(f"Subject: {subject}")

            # Check if ACAPS trigger email
            if TRIGGER_SUBJECT.lower() in subject.lower():
                log("ACAPS trigger email detected!")

                # Mark as read
                mail.store(msg_id, '+FLAGS', '\\Seen')
                log("Email marked as read!")

                return True
            else:
                log("Not an ACAPS email. Skipping...")

        return False

    except Exception as e:
        log(f"Error reading email: {e}")
        return False

#------------------------------------------
# TRIGGER MASTER SCRIPT
#------------------------------------------
def trigger_master_script():
    try:
        log("================================================")
        log("Triggering master.sh...")
        log("================================================")

        process = subprocess.Popen(
            [BASH_PATH, MASTER_SCRIPT],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            bufsize=1,
            universal_newlines=True
        )

        # Print output line by line as it comes
        for line in process.stdout:
            print(line, end='', flush=True)

        # Close stdout explicitly
        process.stdout.close()

        # Wait for completion
        return_code = process.wait()

        if return_code == 0:
            log("================================================")
            log("Master script completed successfully!")
            log("Part 1 and Part 2 executed!")
            log("================================================")
            return True
        else:
            log(f"ERROR: Master script failed!")
            log(f"Return code: {return_code}")
            return False

    except Exception as e:
        log(f"ERROR: Unexpected error: {e}")
        return False

#------------------------------------------
# MAIN LOOP - KEEP WATCHING INBOX
#------------------------------------------
log("================================================")
log("ACAPS Email Watcher Started")
log(f"Watching for: {TRIGGER_SUBJECT}")
log(f"Checking every {CHECK_INTERVAL} seconds")
log("================================================")

while True:
    try:
        # Connect to Gmail
        mail = connect_to_gmail()

        if mail:
            # Check for trigger email
            trigger_found = check_for_trigger_email(mail)

            if trigger_found:
                # Trigger master script
                trigger_master_script()

            # Logout
            mail.logout()
            log("Disconnected from Gmail!")

        else:
            log("Could not connect to Gmail!")

    except Exception as e:
        log(f"Unexpected error in main loop: {e}")
        log("Continuing to next check...")

    # Wait before next check
    log(f"Next check in {CHECK_INTERVAL} seconds...")
    log("------------------------------------------------")
    time.sleep(CHECK_INTERVAL)