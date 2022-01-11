from os import environ

MONGO_URI = f'mongodb://{environ.get("MONGO_USERNAME")}:{environ.get("MONGO_PASSWORD")}@' \
            f'{environ.get("MONGO_HOST")}:{environ.get("MONGO_PORT")}/{environ.get("MONGO_INITDB_DATABASE")}'
