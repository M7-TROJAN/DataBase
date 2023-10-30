# Creating a Synthetic Database using Python's Faker Library

This guide illustrates how to utilize Python in conjunction with the Faker library to produce synthetic data and save it in both a CSV file and an SQLite database.

## Prerequisites
1. Ensure you have Python installed on your system.
2. To install the Faker library, use the following command:
    ```sh
    pip install faker
    ```

## Overview

Creating synthetic data is a fundamental practice in database management, software testing, and learning SQL. Python's Faker library allows you to generate artificial data that closely resembles real-world information. This README demonstrates the creation of synthetic data in both a CSV file and an SQLite database, providing essential hands-on experience for anyone learning database operations.

## Instructions

### Generate Synthetic Data in a CSV File

Use the Faker library and Python's CSV module to fabricate mock data and store it in a CSV file.

#### Code Example:

```python
from faker import Faker
import csv

fake = Faker()

# Generate synthetic data and write to a CSV file
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

## Create a Synthetic Database in SQLite
Utilize the Faker library in combination with the sqlite3 module to generate synthetic data and store it in an SQLite database.

### Code Example:

```python
from faker import Faker
import sqlite3

fake = Faker()

# Establish a connection with an SQLite database
connection = sqlite3.connect('LargeDatabase.sqlite')
cursor = connection.cursor()

# Create a table and insert synthetic data
cursor.execute('''
    CREATE TABLE Users (
        UserID INTEGER PRIMARY KEY,
        FirstName TEXT,
        LastName TEXT,
        Email TEXT,
        Address TEXT
    )
''')

# Insert synthetic data into the "Users" table
for _ in range(1000):  # Adjust the range for the number of entries
    cursor.execute('''
        INSERT INTO Users (FirstName, LastName, Email, Address) VALUES (?, ?, ?, ?)
    ''', (fake.first_name(), fake.last_name(), fake.email(), fake.address()))

# Commit changes and close the connection
connection.commit()
connection.close()
```

## Author

- Mahmoud Mohamed
- Email: mahmoud.abdalaziz@outlook.com
- LinkedIn: [Mahmoud Mohamed Abdalaziz](https://www.linkedin.com/in/mahmoud-mohamed-abd/)


## Importance of Synthetic Databases

Synthetic databases play a crucial role in various fields, including software testing, data analysis, and learning SQL. They help in understanding database operations and serve as test environments for real-world scenarios.

## Importing Synthetic Data to SQL Server

Generated synthetic data in CSV format can be imported into SQL Server Management Studio. Follow the import process to populate tables in SQL Server databases with the synthetic data created from the CSV file.

Happy learning and coding! 🚀
