#!/bin/sh

set -e

CAKey="rsa-caKey.pem"
CAcert="rsa-caCert.pem"
VerificationKey="rsa-verificationCert.key"
VerificationCsr="rsa-verificationCert.csr"
VerificationCert="rsa-verificationCert.crt"

ScriptDir=$(readlink -f $(dirname $0))

CADir=certs/$(date +"%2y%2m%2d-%2H%2M%2S")-ca-rsa
mkdir -p ${CADir}
cd ${CADir}

sh ${ScriptDir}/register_CA_cert.sh "rsa" ${CAKey} ${CAcert} ${VerificationKey} ${VerificationCsr} ${VerificationCert}
