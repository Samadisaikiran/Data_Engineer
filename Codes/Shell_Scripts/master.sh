#!/bin/bash
./acaps_part_1.sh

if [ $? -eq 0 ]; then
	echo ""
	echo "Part_1 Completed Successfully"
	echo "Wait for 30 min"
else
	echo "Part_1 Failed"
	exit 1
fi

minutes=3
while [ $minutes -gt 0 ];do
	echo "Time remaining: $minutes minutes..."
	sleep 60
	minutes=$((minutes -1))
done

echo "Executing Part_2..."
echo ""

./acaps_part_2.sh

if [ $? -eq 0 ]; then
	echo "part_2 Completed successfully"
else
	echo "part_2 Failed"
	exit 1
fi

echo "All ACAPS Files Copied successfully"

exit 0

