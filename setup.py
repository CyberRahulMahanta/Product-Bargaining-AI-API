# setup.py
import mysql.connector
from mysql.connector import Error
import sys

def setup_database():
    """Setup the complete database"""
    
    connection = None
    
    try:
        # Connect to MySQL
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password=""  # Your MySQL password
        )
        
        if connection.is_connected():
            cursor = connection.cursor()
            
            print("🔧 Setting up Bargaining AI Database...")
            
            # Create database
            cursor.execute("CREATE DATABASE IF NOT EXISTS bargain_ai_hybrid")
            cursor.execute("USE bargain_ai_hybrid")
            
            print("✅ Database created")
            
            # Read SQL file
            with open('advanced_bargain_db.sql', 'r') as file:
                sql_commands = file.read().split(';')
            
            # Execute each command
            for command in sql_commands:
                if command.strip():
                    try:
                        cursor.execute(command)
                    except Error as e:
                        print(f"⚠️ Warning: {e}")
            
            connection.commit()
            
            print("✅ Tables created successfully")
            print("✅ Sample data inserted")
            
            # Show summary
            cursor.execute("SHOW TABLES")
            tables = cursor.fetchall()
            
            print(f"\n📊 Database Summary:")
            print(f"   • Database: bargain_ai_hybrid")
            print(f"   • Tables: {len(tables)}")
            
            for table in tables:
                cursor.execute(f"SELECT COUNT(*) FROM {table[0]}")
                count = cursor.fetchone()[0]
                print(f"   • {table[0]}: {count} records")
            
            print("\n🎉 Setup completed successfully!")
            print("\nTo run the AI:")
            print("1. Install dependencies: pip install mysql-connector-python textblob requests")
            print("2. Run: python test_hybrid_bargain.py")
            print("3. Start bargaining!")
    
    except Error as e:
        print(f"❌ Error: {e}")
        sys.exit(1)
    
    finally:
        if connection and connection.is_connected():
            cursor.close()
            connection.close()

if __name__ == "__main__":
    setup_database()