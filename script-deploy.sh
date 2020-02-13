#!/bin/bash
HELP_STRING="Builds, tags and uploads the neccessary images for a backend instance.

Usage:
build-server-images.sh [-h] { testing | production } [--all]

where:
-h show this help
testing uploads the images to be used in testing
testing uploads the images to be used in production"

# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
BASEPATH=$(dirname "$SCRIPT")

cd $BASEPATH/


if [[ $1 == "-h" ]];
then
    echo "$HELP_STRING"
    exit 100
elif [[ $1 == "testing" ]];
then
    TAG="testing"
    DOCKERFILE_BACKEND="./DockerfileTesting"
elif [[ $1 == "production" ]];
then
    TAG="production"
    DOCKERFILE_BACKEND="./DockerfileBackendProduction"
else
    echo "$HELP_STRING"
    exit 101
fi

DATE_STRING="$(date +%Y%m%d%H%M)"

cd $BASEPATH/

docker build -f $DOCKERFILE_BACKEND -t docker.pkg.github.com/toti1212/mwd-docker-compose/flask-backend:$TAG-latest -t docker.pkg.github.com/toti1212/mwd-docker-compose/flask-backend:$TAG-$DATE_STRING .

if [[ $? -eq 0 ]] ;
then
    echo "[OCTOINFO] Flask image build successful"
else
    echo "[OCTOERROR] Faild to build image"
    cd -
    exit 102
fi


docker push docker.pkg.github.com/toti1212/mwd-docker-compose/flask-backend:$TAG-latest && docker push docker.pkg.github.com/toti1212/mwd-docker-compose/flask-backend:$TAG-$DATE_STRING

if [[ $? -eq 0 ]] ;
then
    echo "[OCTOINFO] Flask image pushed successfully"
else
    echo "[OCTOERROR] Faild to push image"
    exit 103
fi

docker build -f nginx/Dockerfile -t docker.pkg.github.com/toti1212/mwd-docker-compose/nginx-backend:$TAG-latest -t docker.pkg.github.com/toti1212/mwd-docker-compose/nginx-backend:$TAG-$DATE_STRING .

if [[ $? -eq 0 ]] ;
then
    echo "[OCTOINFO] Nginx image build successful"
else
    echo "[OCTOERROR] Faild to build image"
    cd -
    exit 102
fi

docker push docker.pkg.github.com/toti1212/mwd-docker-compose/nginx-backend:$TAG-latest && docker push docker.pkg.github.com/toti1212/mwd-docker-compose/nginx-backend:$TAG-$DATE_STRING

if [[ $? -eq 0 ]] ;
then
    echo "[OCTOINFO] Nginx image pushed successfully"
else
    echo "[OCTOERROR] Faild to push image"
    exit 103
fi

echo "[OCTOINFO] All done"
exit

