#!/bin/sh

ScriptDir=$(readlink -f $(dirname $0))

CertDir=certs/$(date +"%2y%2m%2d-%2H%2M%2S")-ecc
mkdir -p ${CertDir}
cd ${CertDir}

AwsIotHost=$1
[ -z ${AwsIotHost} ] && AwsIotHost="a2zopw3obz2cdd-ats.iot.ap-southeast-1.amazonaws.com"

CAKey="ecc-caKey.pem"
CAcert="ecc-caCert.pem"
VerificationKey="ecc-verificationCert.key"
VerificationCsr="ecc-verificationCert.csr"
VerificationCert="ecc-verificationCert.crt"

DevicePrivateKey="ecc-device-privatekey.pem"
DeviceCert="ecc-device-cert.pem"
DeviceCertSigningRequest="ecc-device-cert.csr"

sh ${ScriptDir}/register_CA_cert.sh "ecc" ${CAKey} ${CAcert} ${VerificationKey} ${VerificationCsr} ${VerificationCert}

sh ${ScriptDir}/create_device_cert.sh "ecc" ${CAKey} ${CAcert} ${DevicePrivateKey} ${DeviceCert} ${DeviceCertSigningRequest}

cat ${DeviceCert} ${CAcert} > "ecc-deviceCertAndCA.crt"
mosquitto_pub --cafile ${ScriptDir}/AmazonRootCA1.pem --cert "ecc-deviceCertAndCA.crt" --key ${DevicePrivateKey} -h ${AwsIotHost} -p 8883 -q 1 -t  foo/bar -i anyclientID --tls-version tlsv1.2 -m "Hello" -d
