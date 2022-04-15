# Start container and save the container id
CID=$(docker run -d -e GENERATOR_HOST=http://127.0.0.1:8080 --network host swaggerapi/swagger-generator)
# allow for startup
sleep 5
# Get the IP of the running container
#GEN_IP=$(docker inspect --format '{{.NetworkSettings.IPAddress}}'  $CID)
#echo $GEN_IP
# Execute an HTTP request and store the download link
RESULT=$(curl -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{
  "swaggerUrl": "http://127.0.0.1:8150/api/docs/swagger.json", "options": {"supportsES6": true,"npmVersion": "6.9.0", "typescriptThreePlus": true, "modelPropertyNaming": "original"}
}' 'http://localhost:8080/api/gen/clients/typescript-node' | jq '.link' | tr -d '"')
# Download the generated zip and redirect to a file
rm -rvf typescript-node-client
curl -L $RESULT > result.zip
unzip result.zip
rm result.zip
# Shutdown the swagger generator image
docker stop $CID && docker rm $CID
