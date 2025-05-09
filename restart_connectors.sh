#!/bin/bash

# URL do Kafka Connect
KAFKA_CONNECT_URL="http://localhost:8083/connectors"

# Prompt para o diretório base
read -p "Informe o diretório base dos conectores [/opt/kafka-connect/config]: " INPUT_DIR
BASE_DIR="${INPUT_DIR:-/opt/kafka-connect/config}"

# Criar dinamicamente a lista de conectores com base em arquivos .json
CONNECTORS=(
  $(find "$BASE_DIR" -type f -name "*.json" | sort)
)

# Exibir conectores
echo "Lista de conectores disponíveis para REINICIAR:"
for i in "${!CONNECTORS[@]}"; do
  FILE="${CONNECTORS[$i]}"
  NAME=$(jq -r '.name' "$FILE")
  printf "[%2d] %s\n" $((i+1)) "$NAME"
done

# Entrada do usuário
echo ""
read -p "Digite os números dos conectores que deseja reiniciar (ex: 1 4 7), ou 'all' para todos: " SELECAO

# Converter seleção
if [[ "$SELECAO" == "all" ]]; then
  IDS=($(seq 1 ${#CONNECTORS[@]}))
else
  IDS=($SELECAO)
fi

echo ""
for ID in "${IDS[@]}"; do
  INDEX=$((ID-1))
  FILE="${CONNECTORS[$INDEX]}"
  NAME=$(jq -r '.name' "$FILE")

  if [ "$NAME" == "null" ]; then
    echo "⚠️  Arquivo inválido: $FILE (sem campo 'name')"
    continue
  fi

  echo "🔁 Reiniciando conector: $NAME"
  RESPONSE=$(curl -s -w "HTTPSTATUS:%{http_code}" \
    -X POST "$KAFKA_CONNECT_URL/$NAME/restart")

  BODY=$(echo "$RESPONSE" | sed -e 's/HTTPSTATUS\:.*//g')
  STATUS=$(echo "$RESPONSE" | tr -d '\n' | sed -e 's/.*HTTPSTATUS://')

  if [[ "$STATUS" -ge 200 && "$STATUS" -lt 300 ]]; then
    echo "✅ Conector $NAME reiniciado com sucesso!"
  else
    echo "❌ Erro ao reiniciar $NAME (HTTP $STATUS)"
    echo "📄 Detalhes:"
    echo "$BODY"
  fi

  echo "-----------------------------------------"
done

