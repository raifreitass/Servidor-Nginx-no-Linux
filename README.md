# Serviço Nginx no Ubuntu via WSL 

# Índice
1. Linux no Windows (WSL)
2. Subindo um Servidor Nginx
3. Validação do Status do Nginx
4. Automatização do Script
5. Versionamento com Git



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

O status deve mostrar "active (running)", indicando que o servidor está online. Verifique se o servidor está funcionando acessando o endereço http://localhost no navegador. Se tudo estiver certo, você verá a página de boas-vindas do Nginx.

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

# Automatização do Script
Agora, você vai configurar o script para que ele seja executado automaticamente a cada 5 minutos utilizando a ferramenta `anacron`.

## Passo 1 
O Anacron geralmente já vem instalado em muitas distribuições Linux, mas você pode instalá-lo se necessário:

- Instalação:
`sudo apt install anacron`

- Configuração:
`sudo nano /etc/anacrontab`


- Arraste o cursor de texto até o final da página e adicione essa linha ao arquivo para agendar seu script:

`5       10      cron.daily     /home/seu_usuario/nome_do_seu_diretorio/checar_nginx.sh`

Por fim, salve a edição para retornar na tela inicial do terminal.

# Versionamento com Git
Nesta última etapa, vamos versionar o projeto utilizando o Git.

## Passo 1
- No diretório onde você criou o script, inicialize um repositório Git:

`git init`


-  Adicione todos os arquivos que você deseja versionar:

`git add . `

-  Faça o commit da versão inicial do seu projeto:
  
`git commit -m "Commit do Projeto" `

## Passo 2
Adicione um repositório remoto e envie os commits:

`git remote add origin https://github.com/seu_usuario/seu_repositorio.git`

`git push -u origin master`






 
















