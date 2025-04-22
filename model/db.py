import mysql.connector
from mysql.connector import Error
import os
from dotenv import load_dotenv
from typing import Tuple
from mysql.connector.cursor import MySQLCursor
from mysql.connector.connection import MySQLConnection

# Load environment variables
load_dotenv()

db_config = {
    "host": os.getenv("DB_HOST", "db"),  # Changed to 'db' for Docker
    "user": os.getenv("DB_USER", "root"),
    "password": os.getenv("DB_PASSWORD", "yourpassword"),
    "database": os.getenv("DB_NAME", "jru_system"),
    "port": int(os.getenv("DB_PORT", "3306")),  # Changed to 3306 for internal Docker communication
}

def check_tables():
    connection = None
    cursor = None
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor(dictionary=True)
        cursor.execute("SHOW TABLES;")
        tables = cursor.fetchall()

        if tables:
            print("Tables in database:")
            for table in tables:
                print(list(table.values())[0])
        else:
            print("No tables found in the database.")

    except Error as e:
        print(f"Error connecting to MySQL: {e}")
    finally:
        if cursor:
            cursor.close()
        if connection and connection.is_connected():
            connection.close()

def get_db() -> Tuple[MySQLCursor, MySQLConnection]:
    connection = None
    cursor = None
    try:
        connection = mysql.connector.connect(**db_config)
        cursor = connection.cursor(dictionary=True)
        yield cursor, connection
    except Error as e:
        print(f"Database connection error: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Database connection error: {str(e)}")
    finally:
        if cursor:
            cursor.close()
        if connection and connection.is_connected():
            connection.close()

if __name__ == "__main__":
    check_tables()