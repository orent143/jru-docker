# model/db.py
import mysql.connector

db_config = {
    "host": "localhost",
    "user": "root",
    "password": "",
    "database": "jru_system",
    "port": 3307,
}

def get_db():
    db = mysql.connector.connect(**db_config)
    cursor = db.cursor(dictionary=True)  # Returns results as dictionaries
    try:
        yield cursor
    finally:
        cursor.close()
        db.close()
