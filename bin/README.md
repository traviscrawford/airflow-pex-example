# direnv integration

An awesome feature of direnv is the ability to load an entire directory into the path. We make use of this feature to add an `airflow` symbol directly into the environment. This avoids the need to execute Airflow through the pants cli, providing a completely native experience. 

The use of direnv is not superficial though. It's necessary to have `airflow` in the environment because the cli makes use of it when running individual tasks. 

For example, consider launching the example dag in the main README.

	➜  airflow backfill analytics_daily -s 2018-01-01 -e 2018-01-01
	
	[2018-08-13 15:26:26,933] {__init__.py:45} INFO - Using executor SequentialExecutor
	[2018-08-13 15:26:26,972] {models.py:189} INFO - Filling up the DagBag from /Users/waldo/src/airflow/pex-example/src/dags/analytics/dags
	[2018-08-13 15:26:27,177] {models.py:1197} INFO - Dependencies all met for <TaskInstance: analytics_daily.print_date 2018-01-01 00:00:00 [scheduled]>
	[2018-08-13 15:26:27,180] {base_executor.py:49} INFO - Adding to queue: airflow run analytics_daily print_date 2018-01-01T00:00:00 --local -sd DAGS_FOLDER/analytics_daily.py
	[2018-08-13 15:26:32,131] {sequential_executor.py:40} INFO - Executing command: airflow run analytics_daily print_date 2018-01-01T00:00:00 --local -sd DAGS_FOLDER/analytics_daily.py
	[2018-08-13 15:26:34,571] {__init__.py:45} INFO - Using executor SequentialExecutor
	[2018-08-13 15:26:34,613] {models.py:189} INFO - Filling up the DagBag from /Users/waldo/src/airflow/pex-example/src/dags/analytics/dags/analytics_daily.py
	[2018-08-13 15:26:34,664] {base_task_runner.py:115} INFO - Running: ['bash', '-c', 'airflow run analytics_daily print_date 2018-01-01T00:00:00 --job_id 2 --raw -sd DAGS_FOLDER/analytics_daily.py']
	
You can see in the following line that Airflow calls out to itself via the shell:

`Executing command: airflow run analytics_daily print_date 2018-01-01T00:00:00 --local -sd DAGS_FOLDER/analytics_daily.py
[2018-08-13 15:26:34,571] {__init__.py:45} INFO - Using executor SequentialExecutor`

This is the main reason to use direnv.

Similarly, for the webserver.

	➜  pex-example git:(complete-airflow-features) ✗ airflow webserver
	[2018-08-13 15:29:16,636] {__init__.py:45} INFO - Using executor SequentialExecutor
	  ____________       _____________
	 ____    |__( )_________  __/__  /________      __
	____  /| |_  /__  ___/_  /_ __  /_  __ \_ | /| / /
	___  ___ |  / _  /   _  __/ _  / / /_/ /_ |/ |/ /
	 _/_/  |_/_/  /_/    /_/    /_/  \____/____/|__/
	
	/Users/waldo/src/airflow/pex-example/.pants.d/pyprep/requirements/CPython-3.6.4/81e1b0096394cb92c7b9d075a675485c599e27d4-DefaultFingerprintStrategy_3f82b95bd138/.deps/Flask-0.11.1-py2.py3-none-any.whl/flask/exthook.py:71: ExtDeprecationWarning: Importing flask.ext.cache is deprecated, use flask_cache instead.
	  .format(x=modname), ExtDeprecationWarning
	[2018-08-13 15:29:16,894] {models.py:189} INFO - Filling up the DagBag from /Users/joe.napolitano/src/airflow/pex-example/src/dags/analytics/dags
	Running the Gunicorn Server with:
	Workers: 4 sync
	Host: 0.0.0.0:8080
	Timeout: 120
	Logfiles: - -
	=================================================================
	Running: gunicorn -w 4 -k sync -t 120 -b 0.0.0.0:8080 -n airflow-webserver -p /Users/waldo/src/airflow/pex-example/src/dags/analytics/airflow-webserver.pid -c python:airflow.www.gunicorn_config --access-logfile - --error-logfile - airflow.www.app:
	[2018-08-13 15:29:20 -0400] [20075] [INFO] Starting gunicorn 19.9.0
	
Which calls out to:
`gunicorn -w 4 -k sync -t 120 -b 0.0.0.0:8080 -n airflow-webserver -p /Users/waldo/src/airflow/pex-example/src/dags/analytics/airflow-webserver.pid -c python:airflow.www.gunicorn_config --access-logfile - --error-logfile - airflow.www.app:`