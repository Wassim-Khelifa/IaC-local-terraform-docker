FROM nginx:alpine

# Créer le dossier HTML (il existe parfois mais par précaution)
RUN mkdir -p /var/lib/nginx/html

# Ajouter ton fichier index.html
RUN echo "<h1>Application Deployed via Terraform IaC!</h1>" > /var/lib/nginx/html/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
