# 🛠️ Dev Stack

Environnement de développement local partagé entre tous les projets.

## Prérequis

- Docker Engine : [Debian](https://docs.docker.com/engine/install/debian/#installation-methods) / [macOS](https://blog.stephane-robert.info/docs/conteneurs/moteurs-conteneurs/docker/installation/#alternative--colima) / [Windows](https://www.docker.com/get-started/)

## Installation

```bash
# Créer le réseau partagé
docker network create traefik

# Lancer la stack
docker compose up -d
```

## Services

| Service | URL | Rôle |
|---------|-----|------|
| Traefik | http://traefik.localhost | Reverse proxy |
| Portainer | http://portainer.localhost | GUI Docker |
| MailHog | http://mail.localhost | Catch-all emails |

## 📧 MailHog - Config SMTP pour vos projets

| Paramètre | Valeur |
|-----------|--------|
| **Host** | `mailhog` |
| **Port** | `1025` |
| **Username** | _(vide)_ |
| **Password** | _(vide)_ |
| **Encryption** | aucune |

> ⚠️ Le projet doit être connecté au réseau `traefik`

```yaml
# dans le docker-compose.yml du projet
networks:
  traefik:
    external: true
```

## 🔌 Connecter un projet

```yaml
services:
  app:
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.monprojet.rule=Host(`monprojet.localhost`)"
    networks:
      - traefik

networks:
  traefik:
    external: true
```

## 👥 Contributeurs

- Frize