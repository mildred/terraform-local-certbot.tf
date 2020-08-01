variable "method" {
  description = "certbot method to use (apache, standalone, nginx, ...)"
  default     = "standalone"
}

variable "domains" {
  description = "List of domains to request"
  type        = list
}

variable "email" {
  description = "Contact e-mail address"
}

resource "sys_package" "certbot" {
  type = "deb"
  name = "certbot"
}

resource "sys_null" "certbot" {
  depends_on = [
    sys_package.certbot
  ]
  provisioner "local-exec" {
    command = "certbot -n certonly --${var.method} -d ${join(", ", var.domains)} -m ${var.email} --agree-tos"
  }
}

resource "sys_systemd_unit" "certbot_timer" {
  name = "certbot.timer"
  enable = true
  start = true
}
