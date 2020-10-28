#!/bin/sh

set -e

CAKey="ecc-caKey.pem"
CAcert="ecc-caCert.pem"
VerificationKey="ecc-verificationCert.key"
VerificationCsr="ecc-verificationCert.csr"
VerificationCert="ecc-verificationCert.crt"

ScriptDir=$(readlink -f $(dirname $0))

CADir=certs/$(date +"%2y%2m%2d-%2H%2M%2S")-ca-ecc
mkdir -p ${CADir}
cd ${CADir}

sh ${ScriptDir}/register_CA_cert.sh "ecc" ${CAKey} ${CAcert} ${VerificationKey} ${VerificationCsr} ${VerificationCert}
