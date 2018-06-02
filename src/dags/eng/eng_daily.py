from datetime import datetime, timedelta

from airflow import DAG
from example.airflow.operators.bash_operator import MyBashOperator


dag = DAG(
  dag_id='another_dag',
  default_args={
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2015, 6, 1),
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
  },
)

task = MyBashOperator(
  task_id='print_date',
  bash_command='date',
  dag=dag
)
