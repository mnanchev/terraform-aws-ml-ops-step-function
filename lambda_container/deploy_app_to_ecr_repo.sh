#/bin/bash
AWS_DEFAULT_REGION=eu-central-1
AWS_ACCOUNT_ID=559706524079
check_if_repo_exist=$(aws ecr describe-repositories --repository-names $1 2>&1)
if [ $? -ne 0 ]; then
  if echo $check_if_repo_exist | grep -q RepositoryNotFoundException; then
    aws ecr create-repository --repository-name $1
  else
    >&2 echo $check_if_repo_exist
  fi
fi
docker build $1/cleaning:latest .
aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
docker tag $1:latest $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$1:$latest