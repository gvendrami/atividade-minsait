# prefixo da vm - é utilizada para padronizar os nomes e facilitar o trabalho manual.
variable "vm_prefix" {

  default = "vm-atv-minsait" # inserção nome padrao para utilizar na criação dos recursos, grupo, etc.

}

# grupo de recurso - é a criação do grupo de recursos na azure mesmo chamado 'rg-vm'.
resource "azurerm_resource_group" "rg-vm" {

  name     = "rg-${var.vm_prefix}" # nome do grupo, utilizando o prefixo padronizado anteriormente. entao seria 'rg-' + prefixo.

  location = "Brazil South" # região que o grupo de recursos será criada. nesse caso utilizei o 'brazil south' por ser mais facil de conectar (tive problemas com as regiões mais genéricas por algum motivo, mesmo mudando o tamanho da vm e vendo qual estava disponivel nas regioes, talvez por eu ter acesso de estudante apenas.)
}

# rede virtual - criação da rede virtual na azure. nomeamos como 'vnet-vm' nessa vm.
resource "azurerm_virtual_network" "vnet-vm" {
  name                = "vnet-${var.vm_prefix}" # nome da rede, utilizando novamente o prefixo como padrao. 'vnet-' + prefixo.

  resource_group_name = azurerm_resource_group.rg-vm.name # inserimos a vnet no mesmo grupo de recursos criado anteriormente.
  location            = azurerm_resource_group.rg-vm.location # alocamos ele na mesma localização que o grupo de recursos também.

  address_space       = ["10.0.0.0/16"] # é a definição do espaço de endereçamento da vnet.

}

# sub-rede - aqui é a criação da sub-rede na azure. nomeamos como 'sub-vm'.
resource "azurerm_subnet" "sub-vm" {

  name                 = "sub-${var.vm_prefix}" # nome da sub-rede. novamente utilizamos o prefixo para padronizar os nomes. 'sub-' + prefixo
  
  address_prefixes     = ["10.0.2.0/24"] # aqui definimos o espaço de endereços da sub-rede.

  resource_group_name  = azurerm_resource_group.rg-vm.name # direcionamos a sub-rede para o grupo de recursos que criamos anteriormente.
  virtual_network_name = azurerm_virtual_network.vnet-vm.name # direcionamos a sub-rede para a rede virtual que criamos anteriormente.

}

# ip publico - essa parte é a criação de um ip publico na azure que nomeamos de 'pip-vm'
resource "azurerm_public_ip" "pip-vm" {

  name                = "pip-${var.vm_prefix}" # nome do ip publico. padronizamos conforme o prefixo. 'pip-' + prefixo.

  resource_group_name = azurerm_resource_group.rg-vm.name # associar o ip publico para o grupo de recursos criado anteriormente.
  location            = azurerm_resource_group.rg-vm.location # e direcionar na mesma localização que o grupo de recursos

  allocation_method   = "Static" # aqui é a definição da alocação. ou seja, 'static' para manter o ip fixo ou 'dynamic' para o ip mudar.

}

# interface de rede (nic) - é a criação da interface de rede na azure, nomeada 'nic-vm'.
resource "azurerm_network_interface" "nic-vm" {

  name                = "nic-${var.vm_prefix}" # definir o nome da nic conforme o padrao. 'nic-' + prefixo.

  location            = azurerm_resource_group.rg-vm.location # a nic vai estar na mesma localização que o grupo de recursos.
  resource_group_name = azurerm_resource_group.rg-vm.name # e no mesmo grupo de recursos que criamos antes.
  
  # configuração do  ip da nic
  ip_configuration { 
    name                          = "ip-${var.vm_prefix}" # o nome da configuração do ip da nic será padronizada. 'ip-' + prefixo.

    public_ip_address_id          = azurerm_public_ip.pip-vm.id # aqui associamos o ip publico criado anteriormente com a nic,
    subnet_id                     = azurerm_subnet.sub-vm.id # associar também a sub-rede criada anteriormente com a nic.

    private_ip_address_allocation = "Dynamic" # definir o ip privado a ser alocado de forma dinamica.

  }
}

# maquina virtual linux - aqui ja é a criação da vm em si, com as configurações que inserimos até agora. nomeada como 'vm-atv-minsait'
resource "azurerm_linux_virtual_machine" "vm-atv-minsait" { 
  name                  = "vm-linux-${var.vm_prefix}" # o nome da vm vai ser padronizada: 'vm-linux-' + prefixo.
  
  # a vm vai estar alocada no mesmo grupo de recursos criado anteriormente e na mesma localização.
  resource_group_name   = azurerm_resource_group.rg-vm.name
  location              = azurerm_resource_group.rg-vm.location

  network_interface_ids = [azurerm_network_interface.nic-vm.id] # associamos a nic criada com a vm.

  size               = "Standard_B1s" # o tamanho especificado da vm. existem vários, peguei um genérico e básico para o teste. 'Standard_B1s'.
  
  # essa é a parte da configuração de acesso da vm. obviamente, como tudo até agora, é adaptável para cada ambiente.
  admin_username = "teste" 
  admin_password = "Teste@20204"
  computer_name  = "teste-minsait"
  
  # configuração do docker para rodar na inicialização da vm. nesse caso, o script é codificado em base64.
  custom_data    = base64encode(file("install-docker.sh")) # vale enfatizar que o diretório deve estar dentro do terraform. ou seja, verificar o real diretório do arquivo caso esteja dando algum erro de diretório.

  # essa é a configuração da imagem da vm. utilizei o mais genérico também, por ser mais comum e por ser mais familiar pra mim.
  source_image_reference {

    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"

  }

  # configuração do disco do sistema operacional instalado (linux).
  os_disk {

    name              = "os-disc-linux-${var.vm_prefix}"

    storage_account_type = "Standard_LRS"
    caching           = "ReadWrite"
    
  }

  # habilita o a autenticação por senha para fazer o login na vm.
  disable_password_authentication = false

  # tag apenas para a identificação do ambiente como 'teste'
  tags = {

    environment = "teste"

  }
}