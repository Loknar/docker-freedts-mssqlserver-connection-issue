#!/usr/bin/python3
import platform

import pandas as pd
import pypyodbc


def connect():
    driver = '{FreeTDS}' if platform.system() != 'Windows' else '{ODBC Driver 17 for SQL Server}'
    creds = {
        'server': 'mssqlserver.mydomain.com',
        'port': '1443',
        'database': 'my_database_name',
        'username': 'my_username',
        'password': 'my_password'
    }
    return pypyodbc.connect(
        (
            'DRIVER={driver};'
            'SERVER={server};'
            'PORT={port};'
            'DATABASE={database};'
            'UID={username};'
            'PWD={password};'
            'TDS_Version={tds_version};'
        ).format(
            driver=driver,
            server=creds['server'],
            port=creds['port'],
            database=creds['database'],
            username=creds['username'],
            password=creds['password'],
            tds_version='7.2'
        )
    )


def dummy_query(conn):
    sql_query = '''SELECT * FROM (VALUES ('Hello world'),('Hello world')) t1 (col1) WHERE 1=1'''
    return pd.read_sql(sql_query, conn)


if __name__ == '__main__':
    conn = connect()
    data = dummy_query(conn)
    print(data)
