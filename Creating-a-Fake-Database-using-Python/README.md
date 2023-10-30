# Creating a Fake Database using Python Faker Library

This guide demonstrates how to use Python with the Faker library to generate synthetic data and store it in a CSV file and SQLite database.


## Prerequisites
1. Python installed on your system.
2. Ensure the Faker library is installed. If not, install it using pip:
    ```sh
    pip install faker
    ```


## Instructions
Generate Fake Data in CSV File
Use the Faker library and Python's CSV module to create mock data and save it to a CSV file.

Code Example:
```py
from faker import Faker
import csv

fake = Faker()

# Generate fake data and write to a CSV file
with open('fake_data.csv', 'w', newline='', encoding='utf-8') as csvfile:
    fieldnames = ['FirstName', 'LastName', 'Email', 'Address']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()
    for _ in range(1000):  # Adjust the range for the number of entries
        writer.writerow({
            'FirstName': fake.first_name(),
            'LastName': fake.last_name(),
            'Email': fake.email(),
            'Address': fake.address()
        })
```

## Create a Fake Database in SQLite
Utilize the Faker library along with the sqlite3 module to generate synthetic data and store it in an SQLite database.

Code Example:

```py
from faker import Faker
import sqlite3

fake = Faker()

# Establish a connection with SQLite database
connection = sqlite3.connect('LargeDatabase.sqlite')
cursor = connection.cursor()

# Create a table and insert mock data
cursor.execute('''
    CREATE TABLE Users (
        UserID INTEGER PRIMARY KEY,
        FirstName TEXT,
        LastName TEXT,
        Email TEXT,
        Address TEXT
    )
''')

# Insert mock data into the "Users" table
for _ in range(1000):  # Change the range to determine the number of entries
    cursor.execute('''
        INSERT INTO Users (FirstName, LastName, Email, Address) VALUES (?, ?, ?, ?)
    ''', (fake.first_name(), fake.last_name(), fake.email(), fake.address()))

# Commit changes and close the connection
connection.commit()
connection.close()
```