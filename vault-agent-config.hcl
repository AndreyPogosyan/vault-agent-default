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

template {
  source      = "/etc/vault/ssl/vault_cert.ctmpl"
  destination = "/etc/nginx/ssl/vault_cert.pem"
}

template {
  source      = "/etc/vault/ssl/vault_key.ctmpl"
  destination = "/etc/nginx/ssl/vault_key.pem"
}

# Template group for NGINX certificate and private key with a single reload command
reload_cmd = "systemctl reload nginx"  # Single command to reload NGINX after both files are updated
