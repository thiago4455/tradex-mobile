# Tradex Mobile

Desafio mobile para a vaga na Tradex.

## Objetivos
Desenvolver aplicação mobile capaz de visualizar e adicionar os produtos na API criada no teste anterior.

## Execução do ambiente de desenvolvimento
### Utilizando o Docker
Faça o build ou pull da imagem Docker associada.
É possível então rodar o ambiente através do comando
```bash
docker run --rm -ti -e UID=$(id -u) -e GID=$(id -g) -v "$PWD":/project --privileged -v /dev/bus/usb:/dev/bus/usb flutter
```
Para rodar a aplicação em um dispositivo Android conectado via USB, garanta que não há nenhuma instância do adb rodando na maquina host (fora do docker) usando o comando `adb kill-server`.
Dentro do ambiente podemos então verificar os dispositivos conectados, clonar o repositório e rodar a aplicação;
```bash
adb devices #verificar se o dispositivo foi identificado corretamente
git clone https://github.com/thiago4455/tradex-mobile/ && cd tradex-mobile
flutter run
```
Deverá aparecer uma solicitação de instalação no dispositivo

### Flutter nativo
O processo de instalação do flutter e android-sdk depende do sistema e distribuição. Os passos gerais para um sistema Ubuntu pode ser inspirado no Dockerfile
```bash
sudo apt update
sudo apt install openjdk-17-jdk usbutils android-sdk
sudo chown -R $USER /lib/android-sdk

# Instalando cmdline-tools
curl -o android_tools.zip https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip
unzip -qq -d /lib/android-sdk/cmdline-tools/ android_tools.zip
mv /lib/android-sdk/cmdline-tools/cmdline-tools /lib/android-sdk/cmdline-tools/latest
rm android_tools.zip
sudo ln -s /lib/android-sdk/cmdline-tools/latest/bin/sdkmanager /usr/bin/sdkmanager
yes "y" | sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3"

#Instalando flutter
curl -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.16.4-stable.tar.xz
sudo tar xf flutter.tar.xz -C /usr/share/
rm flutter.tar.xz
sudo ln -s /usr/share/flutter/bin/flutter /usr/bin/flutter
flutter config --no-analytics && flutter precache
yes "y" | flutter doctor --android-licenses
flutter config --no-enable-linux-desktop --no-enable-macos-desktop --no-enable-windows-desktop
```
Atenção: Use apenas um dos métodos (docker ou nativo) na mesma pasta local. Caso seja gerado os arquivos de build em um ambiente, a build irá falhar no outro

## Rodando juntamente com a API
Para executar a aplicação em um dispositivo na rede local, é necessário alterar a constante `_kLocalApiUrl` no arquivo `api.dart` para o IP local da sua máquina (rodando a aplicação Django).

## Implementação
Foram criadas 3 telas. Listagem, visualização e criação de produtos.
### Listagem dos produtos
Essa é a tela principal, onde é possível selecionar um produto para ver os detalhes, e existe o botão de adicionar um novo produto.
![image](https://github.com/thiago4455/tradex-mobile/assets/29243304/b7a79ddd-e54c-420e-89b6-34d81ca950d7)

### Adicionar produto
Nessa tela é possível preencher os dados de um produto, incluindo escolher uma imagem da galeria. O preço escolhido para o produto nessa tela já chama o endpoit de criação de preço também para esse produto
![image](https://github.com/thiago4455/tradex-mobile/assets/29243304/a93aaa14-b17a-426e-9d8a-1400f51269f2)

### Visualizar produto
Nessa tela é possível ver a imagem do produto em um tamanho maior, juntamente com um gráfico da variação do preço com o tempo
![image](https://github.com/thiago4455/tradex-mobile/assets/29243304/6524cdc3-2b7c-47fe-8a60-594debfd5189)
