#!/bin/bash
set -e
echo ""
bash "/c/Users/2320404/OneDrive - Cognizant/documents/github/data_engineer/codes/shell_scripts/acaps_part_1.sh"

minutes=1
while [ $minutes -gt 0 ];do
	echo "Time remaining: $minutes minutes..."
	sleep 5
	minutes=$((minutes -1))
done

echo "Executing Part_2..."
echo ""

bash "/c/Users/2320404/OneDrive - Cognizant/documents/github/data_engineer/codes/shell_scripts/acaps_part_2.sh"

echo "All ACAPS Files Copied successfully"

exit 0