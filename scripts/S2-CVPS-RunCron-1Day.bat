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

set DATE=%date:~0,4%-%date:~5,2%-%date:~8,2%:%time:~0,2%:%time:~3,2%:%time:~6,2%

if "x0" == "x1" (
  echo Init ...
  call python %PYSTOCK_ROOTDIR%/jobs/basic_job.py >%~n0.log 2>&1
)

if "x1" == "x1" (
  if not exist "./data/logs" md data\logs >nul 2>&1

  echo "###################"%DATE%"###################" >> data/logs/daily.0.log
  rem ����ÿ�գ����������ݡ�
  call python %PYSTOCK_ROOTDIR%/jobs/daily_job.py >> data/logs/daily.0.log


  echo "###################"%DATE%"###################" >> data/logs/daily.1.log
  rem ���ӻ�ý���ȫ�����ݺʹ�������
  call python %PYSTOCK_ROOTDIR%/jobs/18h_daily_job.py >> data/logs/daily.1.log

  echo "###################"%DATE%"###################" >> data/logs/daily.2.log
  rem ʹ�ò��岨�ȷ��������Ʊ�ǵ�
  call python %PYSTOCK_ROOTDIR%/jobs/guess_period_daily_job.py >> data/logs/daily.2.log

  echo "###################"%DATE%"###################" >> data/logs/daily.3.log
  rem ʹ�� �ع�ķ���Ԥ�⡣
  call python %PYSTOCK_ROOTDIR%/jobs/guess_return_daily_job.py >> data/logs/daily.3.log

  echo "###################"%DATE%"###################" >> data/logs/daily.4.log
  rem ʹ�ù�Ʊָ��Ԥ�⡣
  call python %PYSTOCK_ROOTDIR%/jobs/guess_indicators_daily_job.py >> data/logs/daily.4.log

  echo "###################"%DATE%"###################" >> data/logs/daily.5.log
  rem ʹ�ù�Ʊָ��Ԥ�⹺��
  call python %PYSTOCK_ROOTDIR%/jobs/guess_indicators_lite_buy_daily_job.py >> data/logs/daily.5.log

  echo "###################"%DATE%"###################" >> data/logs/daily.6.log
  rem ʹ�ù�Ʊָ��Ԥ��������
  call python %PYSTOCK_ROOTDIR%/jobs/guess_indicators_lite_sell_daily_job.py >> data/logs/daily.6.log

  rem ���ǰ3�����ݡ�

)

if "x0" == "x1" (
  echo start ...
  call python %PYSTOCK_ROOTDIR%/web/main.py >%~n0.log 2>&1
)

pause


