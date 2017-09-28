AWS="aws"

APPLICATION_NAME=$(git config --get aws-codedeploy.application-name)
DEPLOYMENT_GROUP=$(git config --get aws-codedeploy.deployment-group)
BUCKET_NAME="your-bucket"
GIT_COMMIT=$(git rev-parse HEAD)
BUNDLE_NAME=$(echo $(basename `pwd`)-$GIT_COMMIT.zip)
MERGE="OVERWRITE"

echo "Pushing $BUNDLE_NAME to s3://${BUCKET_NAME} and registering with application '${APPLICATION_NAME}'" 1>&2

$AWS deploy push \
  --application-name ${APPLICATION_NAME} \
  --s3-location s3://${BUCKET_NAME}/${BUNDLE_NAME} \
  --source .

revision_json="{\"revisionType\":\"S3\",\"s3Location\":{\"bucket\":\"${BUCKET_NAME}\",\"bundleType\":\"zip\",\"key\":\"${BUNDLE_NAME}\"}}"

if [ $? != 0 ]; then
    echo "Falha na criação do deploy. Criação do deploy skipped " 1>&2
else
    echo "Deploying s3://${BUCKET_NAME}/${BUNDLE_NAME} para aplicação ${APPLICATION_NAME} e o grupo ${DEPLOYMENT_GROUP}" 1>&2
    $AWS deploy create-deployment \
        --application-name ${APPLICATION_NAME} \
        --deployment-group-name ${DEPLOYMENT_GROUP} \
        --file-exists-behavior ${MERGE} \
        --revision ${revision_json}
fi
