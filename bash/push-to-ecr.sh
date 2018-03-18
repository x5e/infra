#!/usr/bin/env bash
set -e
function barf { echo -e "\n" BARF: $@ 1>&2; exit 33; }
NAME=${1}
test -n "$NAME" || barf specify repo
printf switching to repo directory:
cd "$(dirname $0)"/../../${NAME}
echo " done (${PWD})"
test -n "${AWS_DEFAULT_REGION}" || barf AWS_DEFAULT_REGION not set
REGION=${AWS_DEFAULT_REGION:-us-east-1}
echo "REGION=${REGION}"
test "${TRAVIS_EVENT_TYPE}" != pull_request || barf "Not pushing to ECR on pull request."

echo getting AWS account number
ACCT=`aws sts get-caller-identity | jq -r .Account`
echo AWS account number is ${ACCT}

echo getting ECR login...
`aws ecr get-login --no-include-email --region ${REGION}`

echo getting git info...
GIT_BRANCH=`cat travis_branch.txt 2> /dev/null || git symbolic-ref -q --short HEAD`
GIT_SHORT=`git rev-parse --short HEAD`
echo GIT_BRANCH=${GIT_BRANCH}
echo GIT_SHORT=${GIT_SHORT}

echo Building docker image...
docker build -t ${NAME} .
echo finished building docker image

echo "ensuring repo..."
aws ecr create-repository --repository-name ${NAME} &> /dev/null || true

echo "tagging..."
docker tag ${NAME} ${ACCT}.dkr.ecr.${REGION}.amazonaws.com/${NAME}:${GIT_BRANCH}
docker tag ${NAME} ${ACCT}.dkr.ecr.${REGION}.amazonaws.com/${NAME}:${GIT_SHORT}

echo "pushing..."
docker push ${ACCT}.dkr.ecr.${REGION}.amazonaws.com/${NAME}:${GIT_BRANCH}
docker push ${ACCT}.dkr.ecr.${REGION}.amazonaws.com/${NAME}:${GIT_SHORT}

echo -e "\n\tDone!"

