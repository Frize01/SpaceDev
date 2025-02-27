# SpaceDev

Ce projet à pour but de me permettre de travailler sur mes projets sur n'importe quelle machine sous Linux. Il me permet aussi de m'exercer sur Docker :)


`UID=$(id -u) GID=$(id -g) docker-compose up -d --build`

ou

```sh
echo "UID=$(id -u)" >> .env
echo "GID=$(id -g)" >> .env
docker-compose up -d --build
```

config laravel : (projet externe à docker)

```sh
DB_CONNECTION=mariadb
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=example_app
DB_USERNAME=root
DB_PASSWORD=root

MAIL_MAILER=smtp
MAIL_HOST=127.0.0.1
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
```

projet interne à Docker :
```sh
DB_CONNECTION=mariadb
DB_HOST=db
DB_PORT=3306
DB_DATABASE=example_app
DB_USERNAME=root
DB_PASSWORD=root

MAIL_MAILER=smtp
MAIL_HOST=127.0.0.1
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
```