variable "display_name" {
  description = "The display name for the application"
  type        = string
}

variable "owners" {
  description = "A list of object IDs of principals that will be granted ownership of the application"
  type        = list(string)
  default     = []
}

variable "redirect_uris" {
  description = "A list of redirect URIs for the application"
  type        = list(string)
  default     = []
}

variable "required_permissions" {
  description = "Required resource access permissions"
  type = list(object({
    id   = string
    type = string
  }))
  default = []
}
