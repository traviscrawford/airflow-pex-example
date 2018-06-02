# airflow-pex-example

Deploying [Apache Airflow](https://airflow.apache.org/) typically involves
installing Airflow and your custom libraries in a `virtualenv` on the production
host, along with your and DAGs & other files (e.g.: SQL). To simplify
deployment, here we explore using [pex](https://pex.readthedocs.io).

Build an Airflow `pex` by running:

```
./pants binary src/python/example/airflow
```

This produces `airflow.pex`, a single file that is analogous to a
statically-lined binary. It's a self-contained, runnable Airflow you can
`scp` to another machine and run.

You can then run Airflow commands as usual, using `dist/airflow.pex`.

```
$ ./dist/airflow.pex list_dags
[2018-04-13 17:34:39,885] {__init__.py:45} INFO - Using executor SequentialExecutor
[2018-04-13 17:34:39,924] {models.py:189} INFO - Filling up the DagBag from /home/travis/airflow/dags


-------------------------------------------------------------------
DAGS
-------------------------------------------------------------------
example_bash_operator
example_branch_dop_operator_v3
example_branch_operator
example_http_operator
example_passing_params_via_test_command
example_python_operator
example_short_circuit_operator
example_skip_dag
example_subdag_operator
example_subdag_operator.section-1
example_subdag_operator.section-2
example_trigger_controller_dag
example_trigger_target_dag
example_xcom
latest_only
latest_only_with_trigger
test_utils
tutorial
```

You can then `scp` or otherwise distribute this file to a production host.


## python_app example

When using Pants 1.7.0rc0 or later which contains `python_app` support we can
build a self-contained binary along with DAGs in a deployable artifact.

Note how `src/dags:analytics` contains a directory of DAGs, which may be useful
if multiple teams require separate DAGs, or you can use just one DAG dir.

```
$ ./pants bundle src/dags:analytics --bundle-py-archive=tgz
$ $ cd dist/src.dags.analytics-bundle/
$ $ find .
.
./main.pex
./analytics
./analytics/analytics_daily.pyc
./analytics/analytics_daily.py
$ AIRFLOW_HOME=$(pwd) AIRFLOW__CORE__DAGS_FOLDER=$(pwd)/analytics ./main.pex list_tasks analytics_daily
[2018-06-01 17:34:47,127] {__init__.py:45} INFO - Using executor SequentialExecutor
[2018-06-01 17:34:47,174] {models.py:189} INFO - Filling up the DagBag from /Users/travis/src/airflow-pex-example/dist/src.dags.analytics-bundle/analytics
print_date
```
