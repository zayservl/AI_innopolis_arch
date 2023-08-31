import psycopg2
from psycopg2 import Error

try:
    # Подключиться к существующей базе данных
    connection = psycopg2.connect(user="zaytsev.svla",
                                  password="!cny1C4Nt",
                                  host="localhost",
                                  port="5432",
                                  database="demo",
                                  options = "-c search_path=bookings")
    cursor = connection.cursor()
    
    cursor.execute("SELECT version();")
    record = cursor.fetchone()
    print("Вы подключены к - ", record, "\n")

    cursor.execute("""
                select * from temp_table
                   """)
    record = cursor.fetchall()
    print("Результат", record)
except (Exception, Error) as error:
    print("Ошибка при работе с PostgreSQL", error)
finally:
    if connection:
        cursor.close()
        connection.close()
        print("Соединение с PostgreSQL закрыто")
