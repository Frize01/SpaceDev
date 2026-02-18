# 🔒 Setup SSL Local avec mkcert + Traefik

## Prérequis

### Installation de mkcert

**macOS**
```bash
brew install mkcert
```

**Linux**
```bash
sudo apt install libnss3-tools   # ou dnf install nss-tools sur Fedora
curl -JLO "https://dl.filippo.io/mkcert/latest?for=linux/amd64"
chmod +x mkcert-v*-linux-amd64
sudo mv mkcert-v*-linux-amd64 /usr/local/bin/mkcert
```

**Windows**
```bash
choco install mkcert
# ou
scoop bucket add extras && scoop install mkcert
```

---

## Installation du CA local

> ⚠️ À faire **une seule fois** par machine

```bash
mkcert -install
```

Cette commande installe un **Certificate Authority (CA) local** dans :
- Le store de confiance de votre OS (utilisé par Safari, Chrome, Edge)
- Firefox (si installé) — sauf sur Windows

---

## Génération des certificats

```bash
mkdir -p certs
mkcert -cert-file certs/local.pem -key-file certs/local-key.pem "*.localhost"
```

```
certs/          ← dans .gitignore ⚠️
├── local.pem
└── local-key.pem
```

> 🔑 Ne jamais commiter les certificats !

---

## Configuration Traefik

### 1. Monter les certificats dans le container

Dans ton `docker-compose.yml` :

```yaml
services:
  traefik:
    image: traefik:v3.6
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./traefik.yml:/etc/traefik/traefik.yml
      - ./certs:/etc/traefik/certs          # ← les certificats
      - ./config:/etc/traefik/config        # ← config dynamique
```

---

### 2. Config statique `traefik.yml`

```yaml
api:
  insecure: true
  dashboard: true

providers:
  docker:
    exposedByDefault: false
  file:
    directory: /etc/traefik/config    # ← pointe vers la config dynamique
    watch: true

entryPoints:
  web:
    address: ":80"
    http:
      redirections:
        entryPoint:
          to: websecure                # ← redirige HTTP → HTTPS auto
          scheme: https
  websecure:
    address: ":443"
```

---

### 3. Config dynamique `config/tls.yml`

```yaml
tls:
  certificates:
    - certFile: /etc/traefik/certs/local.pem
      keyFile: /etc/traefik/certs/local-key.pem
  stores:
    default:
      defaultCertificate:
        certFile: /etc/traefik/certs/local.pem
        keyFile: /etc/traefik/certs/local-key.pem
```

---

### 4. Labels sur tes projets

```yaml
services:
  monapp:
    image: nginx
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.monapp.rule=Host(`monapp.localhost`)"
      - "traefik.http.routers.monapp.entrypoints=websecure"   # ← HTTPS
      - "traefik.http.routers.monapp.tls=true"                # ← active TLS
```

---

## Structure finale

```
traefik/
├── docker-compose.yml
├── traefik.yml
├── config/
│   └── tls.yml
└── certs/              ← dans .gitignore
    ├── local.pem
    └── local-key.pem
```

---

## Test

```bash
docker compose up -d
curl https://monapp.localhost   # 🔒 cadenas vert !
```