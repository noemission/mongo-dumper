# mongo-s3-dumper
A docker image that takes mongo backups using a cron job and uploads them to an s3 bucket.

## Usage

```
docker run -d \
  --env MONGO_HOST=mongo.url \
  --env MONGO_PORT=27017 \
  --env MONGO_USERNAME=admin
  --env MONGO_PASSWORD=pass \
  --env MONGO_DB_NAME=db_name \
  --env S3_BUCKET=s3bucket \
  --env CRON="* * * * *" \
  -v ~/.aws/:/root/.aws:ro \
  rokabilis/mongo-s3-dumper:latest

```

### In docker-compose

```
version: "3.8"
services:
    db:
        image: mongo:5
        restart: unless-stopped
        environment:
            MONGO_INITDB_ROOT_USERNAME: $MONGO_USERNAME
            MONGO_INITDB_ROOT_PASSWORD: $MONGO_PASSWORD
        networks:
            - app-network

    mongo_backup:
        image: rokabilis/mongo-s3-dumper:latest
        restart: unless-stopped
        depends_on:
            - db
        environment: 
            MONGO_HOST: db
            MONGO_PORT: 27017 
            MONGO_USERNAME: $MONGO_USERNAME 
            MONGO_PASSWORD: $MONGO_PASSWORD 
            MONGO_DB_NAME: myDB 
            CRON: "0 */24 * * *" # take backup each day at midnight  
            S3_BUCKET: daily-backups-bucket 
        volumes:
            - ~/.aws/:/root/.aws:ro
        networks:
            - app-network

networks:
    app-network:
        driver: bridge
```

### Notice

All the environment variables are required.

Also mounting the `.aws` folder is required in order for the container to access and upload the backup to s3.