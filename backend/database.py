import mysql.connector
from mysql.connector import Error

def get_db_connection():
    """Create and return a database connection"""
    try:
        connection = mysql.connector.connect(
            host='localhost',
            database='attendance_db',
            user='root',  # Change this
            password='Adhithi@2005'  # Change this
        )
        if connection.is_connected():
            return connection
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        return None

def execute_query(query, params=None, fetch=False):
    """Execute a query and optionally fetch results"""
    connection = get_db_connection()
    if not connection:
        return None
    
    try:
        cursor = connection.cursor(dictionary=True)
        cursor.execute(query, params or ())
        
        if fetch:
            result = cursor.fetchall()
            return result
        else:
            connection.commit()
            return cursor.lastrowid
    except Error as e:
        print(f"Error executing query: {e}")
        return None
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()