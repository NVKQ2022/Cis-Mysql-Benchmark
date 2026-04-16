terraform {
    backend "azurerm" {
        resource_group_name  = "remotebackend-rg"               
        storage_account_name = "remotebackendfortfstate"                                 
        container_name       = "tfstate"                                  
        key                  = "cis-mysql-backend.tfstate"                
    }
}
