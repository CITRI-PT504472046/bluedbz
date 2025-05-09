#!/bin/bash

SERVICE_NAME="debezium.service"

show_menu() {
  echo "🛠️  Gestão do serviço $SERVICE_NAME"
  echo "==================================="
  echo "1) Aplicar alterações ao ficheiro (daemon-reload)"
  echo "2) Ativar o serviço (enable)"
  echo "3) Iniciar o serviço (start)"
  echo "4) Parar o serviço (stop)"
  echo "5) Reiniciar o serviço (restart)"
  echo "6) Ver estado do serviço (status)"
  echo "7) Ver logs em tempo real (journalctl -f)"
  echo "0) Sair"
  echo ""
}

while true; do
  show_menu
  read -p "Escolha uma opção: " OPTION
  echo ""

  case $OPTION in
    1)
      echo "🔄 Executando: sudo systemctl daemon-reload"
      sudo systemctl daemon-reload
      ;;
    2)
      echo "✅ Executando: sudo systemctl enable $SERVICE_NAME"
      sudo systemctl enable "$SERVICE_NAME"
      ;;
    3)
      echo "▶️  Executando: sudo systemctl start $SERVICE_NAME"
      sudo systemctl start "$SERVICE_NAME"
      ;;
    4)
      echo "⏹️  Executando: sudo systemctl stop $SERVICE_NAME"
      sudo systemctl stop "$SERVICE_NAME"
      ;;
    5)
      echo "🔁 Executando: sudo systemctl restart $SERVICE_NAME"
      sudo systemctl restart "$SERVICE_NAME"
      ;;
    6)
      echo "📋 Executando: sudo systemctl status $SERVICE_NAME"
      sudo systemctl status "$SERVICE_NAME"
      ;;
    7)
      echo "📡 Mostrando logs ao vivo do serviço:"
      echo "(Pressione Ctrl+C para sair)"
      sudo journalctl -u "$SERVICE_NAME" -f
      ;;
    0)
      echo "👋 Saindo."
      break
      ;;
    *)
      echo "❌ Opção inválida. Tente novamente."
      ;;
  esac

  echo ""
done

