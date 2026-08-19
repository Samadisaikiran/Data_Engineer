# Create new file: test_connection.py

import socket

print("Testing connection to Gmail IMAP...")

try:
    sock = socket.create_connection(("imap.gmail.com", 993), timeout=10)
    print("SUCCESS: Port 993 is open!")
    print("Connection is not blocked!")
    sock.close()
except Exception as e:
    print(f"FAILED: {e}")
    print("Port 993 is blocked!")