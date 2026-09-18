terraform {
  required_version = ">= 1.3"
  required_providers {
    athenz = {
      source  = "AthenZ/athenz"
      version = ">= 1.0.21"
    }
  }
}
