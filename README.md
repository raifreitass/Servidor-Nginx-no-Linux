# Serviço Nginx no Ubuntu via WSL 

# Índice
1. Linux no Windows (WSL)
2. Subindo um Servidor Nginx
3. Validação do Status do Nginx
4. Automatização do Script
5. Versionamento com Git
6. Verificação do Projeto



# *Linux no Windows (WSL)*
O WSL é um subsistema Linux dentro do Windows, que permite rodar comandos e programas de Linux sem precisar instalar o sistema operacional em outra partição.

## Passo 1
Digite "Windows PowerShell" na barra de pesquisa do gerenciador de tarefas, clique no item com o botão direito do mouse e execute como administrador.

## Passo 2
No PowerShell, digite o seguinte comando para instalar o WSL:

 ` wsl --install `

- Isso irá habilitar o WSL e, se necessário, baixar automaticamente uma distribuição Linux (normalmente o Ubuntu). Caso não instale o Ubuntu automaticamente, digite o comando: 

`wsl --install -d Ubuntu-20.04`

- Se preferir uma versão mais recente, pode substituir o “20.04” por uma versão mais nova, como Ubuntu-22.04.
- Quando finalizar a instalação, realize o seu login como solicitado na tela e anote sua senha, pois ela poderá ser solicitada em outros momentos.

## Passo 3
Reinicie o computador, esse passo é importante para concluir a configuração do WSL. Após a reinicialização, verifique se o WSL está funcionando corretamente:

`wsl -l -v`

## Passo 4
Agora você pode abrir o terminal do Ubuntu pesquisando por ele diretamente na barra de pesquisa ou, se preferir, abra novamente o PowerShell e digite o comando:

`wsl`

# *Subindo um Servidor Nginx*
Vamos proceder com a instalação do Nginx, um dos servidores web mais populares e amplamente utilizados.

## Passo 1
Com o terminal aberto, atualize os pacotes do Ubuntu digitando o comando:

`sudo apt update`

## Passo 2
Em seguida, instale o Nginx:

`sudo apt install nginx`

- Inicie serviço Nginx para que ele comece a rodar:

`sudo systemctl start nginx`

* Para verificar se o Nginx está rodando corretamente, use:
  
`sudo systemctl status nginx`

O status deve indicar "active (running)", mostrando que o servidor está em execução. Para confirmar, abra o navegador e acesse http://localhost. 

# *Validação do Status do Nginx*
Precisamos de um script que irá verificar periodicamente se o Nginx está rodando.

## Passo 1
Crie um diretório onde você deseja alocar o script:

 ` mkdir nome_do_seu_diretorio `
 
Navegue até ele e inicie a criação do arquivo do script, usando o editor ` nano `:

1. ` cd nome_do_seu_diretorio `
   
2. ` nano checar_nginx.sh `

## Passo 2
Insira o seguinte código no script:

```
#!/bin/bash

CAMINHO_LOGS="./"
TEMPO_ATUAL=$(date +'%d-%m-%Y')' '$(date +'%H:%M:%S')
SERVICO="nginx"

if systemctl is-active --quiet "$SERVICO"; then

    echo "$TEMPO_ATUAL - $SERVICO - STATUS: Ativo - Executando." >> "${CAMINHO_LOGS}/nginx_online.log"
else

    echo "TEMPO_ATUAL - $SERVICO - STATUS: Desativo - Não está sendo executado." >> "${CAMINHO_LOGS}/nginx_offline.log"
fi


````
- Aperte CTRL + O, ENTER e CTRL + X para salvar o script e sair da edição.

## Passo 3
Permita o funcionamento do script:

`chmod +x checar_nginx.sh`

- Este comando permite que o script ` checar_nginx.sh ` seja executado como um programa, garantindo que tenha as permissões necessárias para funcionar corretamente.

# *Automatização do Script*
Agora, você vai configurar o script para que ele seja executado automaticamente a cada 5 minutos utilizando a ferramenta `Systemd Timers`.

## Passo 1 
Crie um arquivo de serviço para o seu script executando o comando:

`sudo nano /etc/systemd/system/checar_nginx.service`

- Adicione o seguinte conteúdo ao arquivo:
```
[Unit]
Description=Script para checar o status do Nginx

[Service]
Type=simple
ExecStart=/bin/bash /home/seu_usuario/nome_do_seu_diretorio/checar_nginx.sh
````

Salve e saia do editor (Ctrl + O, Enter, Ctrl + X).

## Passo 2 
Agora, crie o arquivo de timer correspondente:

`sudo nano /etc/systemd/system/checar_nginx.timer`

- Adicione este conteúdo ao arquivo:

```
 [Unit]
Description=Timer para o script de checar o Nginx

[Timer]
OnBootSec=5min
OnUnitActiveSec=5min
Unit=checar_nginx.service

[Install]
WantedBy=timers.target
````
Salve novamente para sair do modo edição.

## Passo 3
Ativar e Iniciar o Timer: 

`sudo systemctl enable checar_nginx.timer
`

- Inicie o timer:
  
`sudo systemctl start checar_nginx.timer
`

- Verificar o Status do Timer:
  
`systemctl list-timers
`

- Verificar os Logs:
  
`journalctl -u checar_nginx.service
`


# *Versionamento com Git*
Nesta última etapa, vamos versionar o projeto utilizando o Git.

## Passo 1
Primeiramente, faça login com sua conta no GitHub pelo o terminal:

`gh auth login
`
- Selecione GitHub.com como a conta que você deseja acessar.
- Escolha HTTPS.
- Confirme que deseja autenticar o Git digitando "y".
- Selecione Login with a web browser.
- Copie o código.
- Abra manualmente o navegador e vá para: https://github.com/login/device
- Cole o código que você copiou e clique em Continue.
- Siga as instruções para concluir a autenticação.

## Passo 2
No diretório onde você criou o script, inicialize um repositório Git:

`git init`


-  Adicione todos os arquivos que você deseja versionar:

`git add . `

-  Faça o commit da versão inicial do seu projeto:
  
`git commit -m "Commit do Projeto" `

## Passo 3
Adicione um repositório remoto e envie os commits:

`git remote add origin https://github.com/seu_usuario/seu_repositorio.git`

`git push -u origin master`

# *Verificação do Projeto*
- Cheque o log de status ativo:

`cat nginx_online.log`

Se o Nginx estiver ativo, o script apenas criará o arquivo nginx_online.log. Para verificar se o log nginx_offline.log será gerado, você pode parar o serviço do Nginx antes de executar o script:

`sudo systemctl stop nginx
`

Após parar o serviço, execute novamente o script:

`./checar_nginx.sh
`

- Cheque o log de status inativo:

`cat nginx_offline.log`

Para ativar o Nginx novamente, você pode usar o seguinte comando:

`sudo systemctl start nginx
`













 
















