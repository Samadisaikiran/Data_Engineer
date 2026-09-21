data = [
    {"city": "Mumbai", "temp": 32},
    {"city": "Delhi", "temp": 38},
    {"city": "Hyderabad", "temp": 35},
]

for row in data:
    print(f"{row['city']}: {row['temp']}°C")


# File handling - Day 1
with open("banking_data.txt", "w") as f:
    f.write("Account: 1001, Balance: 50000\n")
    f.write("Account: 1002, Balance: 75000\n")
    f.write("Account: 1003, Balance: 30000\n")

with open("banking_data.txt", "r") as f:
    content = f.read()
    print(content)

