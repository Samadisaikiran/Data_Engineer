# Test if bash works at all
import subprocess

BASH_PATH = "C:/Program Files/Git/bin/bash.exe"

process = subprocess.Popen(
    [BASH_PATH, "-c", "echo Hello from bash!"],
    stdout=subprocess.PIPE,
    stderr=subprocess.PIPE,
    text=True
)

stdout, stderr = process.communicate()
print(f"Output: {stdout}")
print(f"Error: {stderr}")
print(f"Exit: {process.returncode}")