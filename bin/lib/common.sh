set -euo pipefail

[[ -f .current_project ]] || change_project analytics
CURRENT_DAG_FOLDER=$(cat .current_project)
[[ -z $CURRENT_DAG_FOLDER ]] && { printf "CURRENT_DAG_FOLDER not set\n"; exit 1; }

mkdir -p "$(pwd)/airflow/${CURRENT_DAG_FOLDER}"

export AIRFLOW_HOME="$(pwd)/src/dags/${CURRENT_DAG_FOLDER}"
export AIRFLOW__CORE__AIRFLOW_HOME="$(pwd)/src/dags/${CURRENT_DAG_FOLDER}"
export AIRFLOW__CORE__DAGS_FOLDER="$(pwd)/src/dags/${CURRENT_DAG_FOLDER}/dags"
export AIRFLOW__CORE__BASE_LOG_FOLDER="$(pwd)/airflow/${CURRENT_DAG_FOLDER}/logs"
export AIRFLOW__CORE__SQL_ALCHEMY_CONN="sqlite:///$(pwd)/airflow/${CURRENT_DAG_FOLDER}/airflow.db"
export AIRFLOW__CORE__LOAD_EXAMPLES="False"
export AIRFLOW__CORE__PLUGINS_FOLDER="$(pwd)/src/dags/${CURRENT_DAG_FOLDER}/plugins"
export AIRFLOW__SCHEDULER__CHILD_PROCESS_LOG_DIRECTORY="$(pwd)/airflow/${CURRENT_DAG_FOLDER}/logs/scheduler"

# Dev key
export AIRFLOW__CORE__FERNET_KEY="niGEKijk3iVgtoybG5w049OZo2kQz-ZY4p14f0gAlRs="
