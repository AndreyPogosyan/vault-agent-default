pid_file = "./pidfile"

vault {
  address = ""
  retry {
    num_retries = 3
  }
}

auto_auth {
  method "approle" {
    mount_path = "auth/approle"
    config = {
      role_id_file_path = "./role_id"
      secret_id_file_path = "./secret_id"
      remove_secret_id_file_reading = false
    #   secret_id_response_wrapping_path = ""
    }
    namespace = "admin"
  }

  sink "file" {
    config = {
      path = "./vault_token"
      mode = 0644
    }
  }

listener "tcp" {
  address = "127.0.0.1:8100"
  tls_disable = true
}

# New template for NGINX SSL certificate
template {
  source      = "/etc/vault/ssl/vault_cert.ctmpl"      # Template file for the certificate
  destination = "/etc/nginx/ssl/vault_cert.pem"       # Destination path for NGINX SSL certificate

  command = "systemctl reload nginx"                  # Reload NGINX after certificate update
}

# New template for NGINX SSL key
template {
  source      = "/etc/vault/ssl/vault_key.ctmpl"      # Template file for the private key
  destination = "/etc/nginx/ssl/vault_key.pem"       # Destination path for NGINX SSL private key

  command = "systemctl reload nginx"                  # Reload NGINX after private key update
}
