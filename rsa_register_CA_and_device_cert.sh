#!/bin/sh

ScriptDir=$(readlink -f $(dirname $0))

CertDir=certs/$(date +"%2y%2m%2d-%2H%2M%2S")-rsa
mkdir -p ${CertDir}
cd ${CertDir}

AwsIotHost=$1
[ -z ${AwsIotHost} ] && AwsIotHost="a2zopw3obz2cdd-ats.iot.ap-southeast-1.amazonaws.com"

CAKey="rsa-caKey.pem"
CAcert="rsa-caCert.pem"
VerificationKey="rsa-verificationCert.key"
VerificationCsr="rsa-verificationCert.csr"
VerificationCert="rsa-verificationCert.crt"

DevicePrivateKey="rsa-device-privatekey.pem"
DeviceCert="rsa-device-cert.pem"
DeviceCertSigningRequest="rsa-device-cert.csr"

sh ${ScriptDir}/register_CA_cert.sh "rsa" ${CAKey} ${CAcert} ${VerificationKey} ${VerificationCsr} ${VerificationCert}

sh ${ScriptDir}/create_device_cert.sh "rsa" ${CAKey} ${CAcert} ${DevicePrivateKey} ${DeviceCert} ${DeviceCertSigningRequest}

cat ${DeviceCert} ${CAcert} > "rsa-deviceCertAndCA.crt"
mosquitto_pub --cafile ${ScriptDir}/AmazonRootCA1.pem --cert "rsa-deviceCertAndCA.crt" --key ${DevicePrivateKey} -h ${AwsIotHost} -p 8883 -q 1 -t  foo/bar -i anyclientID --tls-version tlsv1.2 -m "Hello" -d
