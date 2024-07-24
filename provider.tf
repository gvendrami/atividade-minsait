# é a configuração do terraform para utilizar o provedor azure que utilizei no teste.
terraform {
  required_providers {

    azurerm = { # especifica que vamos utilizar o provedor 'azurerm' para interagir com a azure.

      source  = "hashicorp/azurerm" # local de onde o provedor deve ser baixado.
      version = ">= 3.70.0" # definição da versão mínima do provedor que utilizarei,

    }
  }
}

provider "azurerm" { # configuração do provedor azure.

  features {} # configura o provedor com algumas funcionalidades padroes.
  
}