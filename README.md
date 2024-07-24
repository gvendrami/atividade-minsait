# Projeto de Deploy do WordPress na Azure com Terraform e Docker

Este projeto configura uma máquina virtual na Azure, instala o Docker e sobe um container com o WordPress. Ele utiliza Terraform para automatizar o processo.

## Pré-Requisitos

Antes de começar, certifique-se de ter as seguintes ferramentas instaladas e configuradas:

1. **Terraform**: [Instalação do Terraform](https://www.terraform.io/downloads.html)
2. **Azure CLI**: [Instalação do Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
3. **Git**: [Instalação do Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

Você também precisa de:

- **Conta na Azure**: Para criar recursos na Azure.
- **Acesso ao repositório GitHub**: Para clonar e enviar código.

É possível executar tudo no CMD da sua máquina, sem necessidade de algum aplicativo de editor de código.

## Passos para Execução

1. **Clone o Repositório**

   ```bash
   git clone [https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git](https://github.com/gvendrami/atividade-minsait.git)
   cd SEU_REPOSITORIO
   ```

2. **Configure as Credenciais da Azure**

Se você ainda não estiver autenticado na Azure CLI, execute:

   ```bash
   az login
   ```

Apenas seguir o passo a passo que será apresentado no terminal.
Entre em uma conta que possua acesso para criar Máquinas Virtuais dentro da Azure.

3. **Inicialize o Terraform**

Após a extração dos arquivos e especificar o diretório onde os mesmos se encontram, apenas inicie o terraform com o seguinte comando:

   ```bash
   terraform init
   ```

Este comando inicializa o diretório de trabalho do Terraform, baixando o provedor da Azure e configurando o ambiente.

4. **Revise o Plano do Terraform**

  ```bash
  terraform plan
  ```

Esse comando não é obrigatório para rodar em si a aplicação. O objetivo dela é revisar o conteúdo que o terraform pretende criar. É mais para uma revisão geral da saída desse comando.

Me ajudou muito para modificar os arquivos e para revisar ele,

**Obs.: Caso tenha problemas com o diretório do 'custom_data', apenas mude o diretório para o da instalação do arquivo .sh**

5. **Aplique o Plano do Terraform**

   ```bash
   terraform apply
   ```

## Verificar a Instalação na VM

Para verificar se está tudo em conforme após a instalação da vm, coloquei alguns comandos de verificação abaixo.

1. **Acessar a Máquina Virtual**

Dentro do terminal ou WSL, informe o seguinte código.

   ```bash
   ssh teste@(PUBLIC_IP)
   ```

Entre no site da Azure e acesse a máquina virtual criada. Lá vai estar exibindo o IP Público para acessar a vm.

2. **Verificar a Instalação do Docker**

Após conectar-se à VM, execute os seguintes comandos para verificar se o Docker e o Docker Compose estão instalados:

   ```bash
   docker --version
   docker-compose --version
   ```

As saídas devem mostrar as versões instaladas.

3. **Verificar Containers em Execução**

Para verificar se os containers criados do WordPress e do MySQL estão em execução, use o comando;

   ```bash
   docker ps
   ```

Deve exibir os dois containers listados.

4. **Verificar a Instalação do WordPress**

No navegador, acesse o IP público da VM na porta 8080:

   ```bash
   http://(PUBLIC_IP):8080
   ```

Você deve ver a página inicial do WordPress, indicando que a instalação deu certo.

## Conclusão

Gostaria agradecer do fundo do meu coração pela incrível oportunidade que me ofereceram. Aprendi muito com os professores e colegas durante o curso. Sempre ouvi falar bem da Minsait e fiquei muito interessado em fazer parte da equipe. Agora posso dizer com certeza que a Minsait é realmente ótima. O processo seletivo foi impecável e o aprendizado extremamente valioso, o que certamente merece destaque.

Estou animado para colocar em prática todo esse conhecimento na Minsait, junto com o que já sabia. Espero contribuir muito e crescer ainda mais com a equipe.

Muito obrigado por tudo!

