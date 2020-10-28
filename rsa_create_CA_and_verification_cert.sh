#!/bin/sh

set -e

Usage="Usage:  $0 <Aws Iot CA registration code>"

ScriptDir=$(readlink -f $(dirname $0))

CADir=certs/$(date +"%2y%2m%2d-%2H%2M%2S")-ca-rsa
mkdir -p ${CADir}
cd ${CADir}

RegistrationCode=$1
if [ -z ${RegistrationCode} ]
then
    printf "\n\n${Usage}\n\n"
    exit 1
fi

CAKey="rsa-caKey.pem"
CAcert="rsa-caCert.pem"
VerificationKey="rsa-verificationCert.key"
VerificationCsr="rsa-verificationCert.csr"
VerificationCert="rsa-verificationCert.crt"

sh ${ScriptDir}/create_CA_cert.sh "rsa" ${CAKey} ${CAcert}

sh ${ScriptDir}/create_CA_verification_cert.sh "rsa" ${CAKey} ${CAcert} ${RegistrationCode} ${VerificationKey} ${VerificationCsr} ${VerificationCert}
