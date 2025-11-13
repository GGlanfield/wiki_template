#!/bin/sh

# create our own self signed certs. If they already exist, then skip.
serverEmailContact=$EMAIL_CONTACT
domainName=$APACHE_HOSTNAME
selfSignedDetails='/C=UK/ST=County/L=UK/O=UK/OU=Dev/CN='"$domainName"''
certFileParent=""$CERTIFICATE_PATH"/"
certFile=""$certFileParent"project.crt"
certKeyFile=""$certFileParent"project.key"

readmecontents="This folder is where our self signed certs and keys will be stored.
If they do not exist, they will be created the first time you run the webserver container."

readme_path=""$certFileParent"/cert_readme.txt"

if [ ! -d "$certFileParent" ]; then
  mkdir -p "$certFileParent"
fi

if [ ! -f "$readme_path" ]; then
 echo "$readmecontents" > "$readme_path"
fi

if [ ! -f "${certKeyFile}" ] || [ ! -f "${certFile}" ]; then

    echo "Self signed certificate or key missing - creating new ones..."

    openssl req -newkey rsa:4096 -x509 -days 50000 -nodes -out "${certFile}" -keyout "${certKeyFile}" -subj "${selfSignedDetails}"

    if [ $? != 0 ]; then
        echo "Error creating self signed certificate"
        exit 1;
    fi
else
    echo "Found existing certificates, so not creating new ones."
fi

#check our certificate is valid
openssl x509 -in "$certFile" -noout -nocert &> /dev/null

if [ $? != 0 ]; then
        echo "The file "$certFile" did not pass the certificate file checker"
        exit 1;
fi

#check our key is valid
openssl rsa -in "$certKeyFile" -check -noout &> /dev/null

if [ $? != 0 ]; then
        echo "The file "$certKeyFile" did not pass the private key checker"
        exit 1;
fi

#we override the entrypoint, so need to start apache manually
/usr/local/bin/httpd-foreground
