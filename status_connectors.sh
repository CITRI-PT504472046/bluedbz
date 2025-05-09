#!/bin/bash

# Endereço do Kafka Connect
KAFKA_CONNECT_URL="http://localhost:8083/connectors"

# Prompt para o diretório base
read -p "Informe o diretório base dos conectores [/opt/kafka-connect/config]: " INPUT_DIR
BASE_DIR="${INPUT_DIR:-/opt/kafka-connect/config}"

# Criar dinamicamente a lista de conectores com base em arquivos .json
CONNECTORS=(
  $(find "$BASE_DIR" -type f -name "*.json" | sort)
)

# Tabela de status
printf "\n%-35s | %-10s | %-20s | %-10s\n" "Conector" "Status" "Worker" "Tasks"
echo "$(printf -- '-%.0s' {1..85})"

# Loop para verificar o status de cada conector
for CONNECTOR_FILE in "${CONNECTORS[@]}"; do
  CONNECTOR_NAME=$(jq -r '.name' "$CONNECTOR_FILE")

  if [ "$CONNECTOR_NAME" == "null" ]; then
    printf "%-35s | %-10s | %-20s | %-10s\n" "Arquivo inválido" "-" "-" "-"
    continue
  fi

  STATUS_JSON=$(curl -s "$KAFKA_CONNECT_URL/$CONNECTOR_NAME/status")

  if [ -z "$STATUS_JSON" ]; then
    printf "%-35s | %-10s | %-20s | %-10s\n" "$CONNECTOR_NAME" "Erro" "-" "-"
  else
    CONNECTOR_STATE=$(echo "$STATUS_JSON" | jq -r '.connector.state')
    WORKER_ID=$(echo "$STATUS_JSON" | jq -r '.connector.worker_id')
    TASKS_STATE=$(echo "$STATUS_JSON" | jq -r '[.tasks[].state] | join(",")')

    printf "%-35s | %-10s | %-20s | %-10s\n" "$CONNECTOR_NAME" "$CONNECTOR_STATE" "$WORKER_ID" "$TASKS_STATE"

    if [[ "$CONNECTOR_STATE" == "FAILED" ]]; then
      ERROR_MSG=$(echo "$STATUS_JSON" | jq -r '.connector.trace // "(sem mensagem de erro)"')
      echo -e "\e[31m  ↳ Erro: $ERROR_MSG\e[0m"
    fi
  fi

done

printf "\n"
echo "Legenda: Status = RUNNING / FAILED / UNASSIGNED etc."
