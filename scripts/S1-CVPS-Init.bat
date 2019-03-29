@echo off

cd /d "%~dp0"

if "x%MINICONDA_ROOTDIR%" == "x" set MINICONDA_ROOTDIR=D:\pgm\DEV\Miniconda\Miniconda3
if "x%MINICONDA_ENV%" == "x"         set MINICONDA_ENV=envWbkPy3

call %MINICONDA_ROOTDIR%\x64\Scripts\activate.bat %MINICONDA_ROOTDIR%\x64\envs\%MINICONDA_ENV%

if "x0" == "x1" (
    pip install mysqlclient sqlalchemy
    pip install requests
    pip install lxml bs4
    pip install numpy pandas 
    pip install tushare
    pip install tornado torndb
    pip install bokeh stockstats

rem    pip install TA-Lib
)

pushd %cd%
cd ..
set PYSTOCK_ROOTDIR=%cd:\=/%
popd
set PYTHONPATH=%PYSTOCK_ROOTDIR%

set MYSQL_HOST=localhost
set MYSQL_USER=root
set MYSQL_PWD=123456
set MYSQL_DB=stock_data

if not exist "./data" mkdir data >nul 2>&1

if "x1" == "x1" (
  echo Init ...
  call python %PYSTOCK_ROOTDIR%/jobs/basic_job.py >%~n0.log 2>&1
)

if "x0" == "x1" (
  echo start ...
  call python %PYSTOCK_ROOTDIR%/web/main.py >%~n0.log 2>&1
)

pause


