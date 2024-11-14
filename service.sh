#!/bin/bash

# Função para verificar se o serviço existe
check_service() {
  if ! docker ps -a | grep -q "$1"; then
    echo "Serviço $1 não encontrado."
    exit 1
  fi
}

# Função para criar um serviço a partir de uma imagem existente
create_service_from_image() {
  docker run -d --name $1 $2
  echo "Serviço $1 criado a partir da imagem $2."
}

# Função para criar um serviço a partir de um Dockerfile
create_service_from_dockerfile() {
  docker build -t $1 .
  docker run -d --name $1 $1
  echo "Serviço $1 criado a partir do Dockerfile."
}

# Função para iniciar um serviço
start_service() {
  check_service $1
  docker start $1
  echo "Serviço $1 iniciado."
}

# Função para parar um serviço
stop_service() {
  check_service $1
  docker stop $1
  echo "Serviço $1 parado."
}

# Função para excluir um serviço
remove_service() {
  check_service $1
  docker rm $1
  echo "Serviço $1 excluído."
}

# Verifica se foram passados os argumentos corretos
if [ $# -ne 3 ]; then
  echo "Uso: $0 <serviço> <ação> <imagem/Dockerfile>"
  echo "Ações disponíveis: create, start, stop, remove"
  exit 1
fi

# Executa a ação correspondente
case "$2" in
  create)
    if [[ -f Dockerfile ]]; then
      create_service_from_dockerfile "$1"
    else
      create_service_from_image "$1" "$3"
    fi
    ;;
  start)
    start_service "$1"
    ;;
  stop)
    stop_service "$1"
    ;;
  remove)
    remove_service "$1"
    ;;
  *)
    echo "Ação inválida. Use 'create', 'start', 'stop' ou 'remove'."
    exit 1
    ;;
esac
