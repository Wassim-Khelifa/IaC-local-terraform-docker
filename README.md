# TP - IaC local avec Terraform + Docker

Ce dépôt contient une solution pédagogique pour déployer localement une application web
et une base PostgreSQL via Terraform en utilisant le provider Docker.

Prérequis
- Docker (Docker Desktop ou Docker Engine)
- Terraform CLI (>= 1.0)
- Git

Commandes DLC (local)
1. Initialisation
```
terraform init
```
2. Planification
```
terraform plan
```
3. Application
```
terraform apply -auto-approve
```
4. Validation
Ouvrir `http://localhost:8080` (ou le port configuré dans `variables.tf`)

5. Destruction
```
terraform destroy -auto-approve
```

Pipeline CI/CD
Le fichier GitHub Actions est `.github/workflows/main.yml` et exécute `terraform init`,
`terraform plan` et, sur la branche `main`, `terraform apply`. Le pipeline s'appuie sur un
runner Ubuntu disposant de Docker pour exécuter le provider Docker.

Questions de révision (réponses courtes)

1) Impact de `terraform destroy` sur `terraform.tfstate`
- `terraform destroy` supprime les ressources réelles et met à jour/écrase le fichier
  `terraform.tfstate` pour refléter l'absence des ressources créées. Le fichier d'état
  reste (vide ou avec métadonnées) et sert à réconcilier l'infrastructure réelle avec
  le code lors des prochaines opérations.

2) Immuabilité de l'infrastructure
- L'immuabilité signifie que les modifications sont réalisées en remplaçant des
  ressources plutôt qu'en modifiant l'existant. Cela réduit les dérives et facilite
  le retour arrière en déployant de nouvelles instances au lieu de patcher les
  existantes.

3) Rôle de `terraform plan`
- `terraform plan` agit comme une porte/garde car il montre précisément les
  changements qui seront appliqués. En production, il permet une revue et évite des
  modifications inattendues avant l'étape `apply`.

4) Ressource pour créer un réseau Docker
- Utiliser `docker_network` (ex: `resource "docker_network" "tp_net" { name = "tp-net" }`) et
  connecter les conteneurs avec `networks_advanced` ou `networks` sur les conteneurs.
