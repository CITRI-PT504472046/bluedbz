#!/bin/bash

# Caminho dos scripts auxiliares (ajuste se necessário)
SCRIPTS_DIR="$(dirname "$0")"

function show_menu() {
  echo "===================="
  echo "📦 Kafka Connect Menu"
  echo "===================="
  echo "1) Adicionar conectores (create)"
  echo "2) Status dos conectores"
  echo "3) Atualizar configurações"
  echo "4) Pausar conectores"
  echo "5) Reiniciar conectores"
  echo "6) Remover conectores"
  echo "7) Iniciar conectores"
  echo "8) Gerir serviço Debezium"
  echo "0) Sair"
  echo ""
}

while true; do
  show_menu
  read -p "Escolha uma opção: " OPTION
  echo ""

  case $OPTION in
    1)
      bash "$SCRIPTS_DIR/start_connectors.sh"
      ;;
    2)
      bash "$SCRIPTS_DIR/status_connectors.sh"
      ;;
    3)
      bash "$SCRIPTS_DIR/update_connectors.sh"
      ;;
    4)
      bash "$SCRIPTS_DIR/pause_connectors.sh"
      ;;
    5)
      bash "$SCRIPTS_DIR/restart_connectors.sh"
      ;;
    6)
      bash "$SCRIPTS_DIR/delete_connectors.sh"
      ;;
    7)
      bash "$SCRIPTS_DIR/resume_connectors.sh"
      ;;
    8)
      bash "$SCRIPTS_DIR/debezium_manager.sh"
      ;;
    0)
      exit 0
      ;;
    *)
      echo "❌ Opção inválida. Tente novamente."
      ;;
  esac

  echo ""
  read -p "Pressione ENTER para voltar ao menu principal..."
  clear
done

