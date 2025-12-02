terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "postgres_image" {
  name         = "postgres:latest"
  keep_locally = true
}

resource "docker_container" "db_container" {
  name  = "tp-db-postgres"
  image = docker_image.postgres_image.image_id

  ports {
    internal = 5432
    external = var.db_port_external
  }

  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}",
  ]
}

resource "docker_image" "app_image" {
  # Use a prebuilt local image to avoid Terraform/Docker build streaming issues.
  # Build locally with: `docker build -t tp-web-app:latest -f Dockerfile_app .`
  name = "tp-web-app:latest"
  keep_locally = true
}

resource "docker_container" "app_container" {
  name  = "tp-app-web"
  image = docker_image.app_image.image_id

  depends_on = [docker_container.db_container]

  ports {
    internal = 80
    external = var.app_port_external
  }
}