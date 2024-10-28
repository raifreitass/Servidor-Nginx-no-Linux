#!/bin/bash

CAMINHO_LOGS="./"
TEMPO_ATUAL=$(date +'%d-%m-%Y')' '$(date +'%H:%M:%S')
SERVICO="nginx"

if systemctl is-active --quiet "$SERVICO"; then

    echo "$TEMPO_ATUAL - $SERVICO - STATUS: Ativo - Executando." >> "${CAMINHO_LOGS}/nginx_online.log"
else

    echo "TEMPO_ATUAL - $SERVICO - STATUS: Desativo - Não está sendo executado." >> "${CAMINHO_LOGS}/nginx_offline.log"
fi

