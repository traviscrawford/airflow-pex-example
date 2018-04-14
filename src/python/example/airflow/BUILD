python_binary(
  dependencies=[
    '3rdparty/python:apache-airflow',
  ],
  # The airflow script has some logic that cannot be called as a module,
  # so we copy the script into this repo. Ideally this would be fixed upstream.
  source='main.py',
)

