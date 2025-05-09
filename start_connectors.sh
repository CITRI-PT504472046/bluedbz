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

# Loop para ativar conectores
for CONNECTOR_FILE in "${CONNECTORS[@]}"; do
  echo "Ativando conector: $CONNECTOR_FILE"
  curl -s -o /dev/null -w "Status: %{http_code}\n" \
    -H "Content-Type: application/json" \
    -X POST "$KAFKA_CONNECT_URL" \
    -d @"$CONNECTOR_FILE"

  sleep 5 # opcional: evita sobrecarregar o Kafka Connect
done

