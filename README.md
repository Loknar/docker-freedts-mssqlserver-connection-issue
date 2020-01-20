# FreeTDS MSSQLSERVER connection issue

I'm having issues connecting to MSSQL Server using FreeTDS in `python:3.7-slim-buster` docker image.

## When running on Windows

works fine

`python example.py`

```
          col1
0  Hello world
1  Hello world
```

## When using docker

doesn't work

### Building docker image

`docker build . -t freetds_issue`

### Running docker image

`docker run freetds_issue`

```
Traceback (most recent call last):
  File "example.py", line 51, in <module>
    conn = connect()
  File "example.py", line 40, in connect
    tds_version='7.2'
  File "/usr/local/lib/python3.7/site-packages/pypyodbc.py", line 2454, in __init__
    self.connect(connectString, autocommit, ansi, timeout, unicode_results, readonly)
  File "/usr/local/lib/python3.7/site-packages/pypyodbc.py", line 2507, in connect
    check_success(self, ret)
  File "/usr/local/lib/python3.7/site-packages/pypyodbc.py", line 1009, in check_success
    ctrl_err(SQL_HANDLE_DBC, ODBC_obj.dbc_h, ret, ODBC_obj.ansi)
  File "/usr/local/lib/python3.7/site-packages/pypyodbc.py", line 987, in ctrl_err
    raise DatabaseError(state,err_text)
pypyodbc.DatabaseError: ('08S01', '[08S01] [FreeTDS][SQL Server]Unable to connect: Adaptive Server is unavailable or does not exist')
```

`docker run -it --entrypoint "/bin/bash" freetds_issue`

Output of `tsql -C`:

```
Compile-time settings (established with the "configure" script)
                            Version: freetds v1.00.104
             freetds.conf directory: /etc/freetds
     MS db-lib source compatibility: no
        Sybase binary compatibility: yes
                      Thread safety: yes
                      iconv library: yes
                        TDS version: 4.2
                              iODBC: no
                           unixodbc: yes
              SSPI "trusted" logins: no
                           Kerberos: yes
                            OpenSSL: no
                             GnuTLS: yes
                               MARS: no
```

Output of `tsql -LH {server_ip}`:

```
     ServerName SERVERNAME
   InstanceName MSSQLSERVER
    IsClustered No
        Version 14.0.1000.169
            tcp 1433
```

strangely, using `tsql` CLI to connect seems to work ..

`tsql -S mssqlserver.mydomain.com -U my_username`

```
Password:
locale is "C.UTF-8"
locale charset is "UTF-8"
using default charset "UTF-8"
1> exit
```
