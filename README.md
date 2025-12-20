# Requirements
- docker and docker-compose
- vault cli with a running vault instance

# To initialize credentials env variables
```bash
./init.sh <vault hostname> <vault token>
```
This will create data directories, and retrieve secrets from vault, then write them into `secrets.env`

# To run gitlab
```bash
docker compose up -d
```
