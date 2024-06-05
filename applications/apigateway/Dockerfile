FROM sagcr.azurecr.io/apigateway:10.15
USER root
RUN microdnf install zip -y
USER sagadmin
ADD --chown=sagadmin ./apigateway/sourcecode/ /opt/softwareag/apigwassets
ADD --chown=sagadmin ./apigateway/manifests/asset-import.sh /opt/softwareag/apigwassets/asset-import.sh
ADD --chown=sagadmin ./apigateway/manifests/entrypoint.sh /opt/softwareag/apigwassets/entrypoint.sh
