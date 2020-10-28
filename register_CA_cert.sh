#!/bin/sh

set -e

ScriptDir=$(readlink -f $(dirname $0))

Algo=$1; shift

CAKey=$1; shift
[ -z ${CAKey} ] && CAKey="ecc-caKey.pem"
CAcert=$1; shift
[ -z ${CAcert} ] && CAcert="ecc-caCert.pem"

VerificationKey=$1; shift
[ -z ${VerificationKey} ] && VerificationKey="ecc-verificationCert.key"

VerificationCsr=$1; shift
[ -z ${VerificationCsr} ] && VerificationCsr="ecc-verificationCert.csr"

VerificationCert=$1; shift
[ -z ${VerificationCert} ] && VerificationCert="ecc-verificationCert.crt"

sh ${ScriptDir}/create_CA_cert.sh ${Algo} ${CAKey} ${CAcert}

RegistrationCode=$(aws iot get-registration-code | jq -r .registrationCode)

sh ${ScriptDir}/create_CA_verification_cert.sh ${Algo} ${CAKey} ${CAcert} ${RegistrationCode} ${VerificationKey} ${VerificationCsr} ${VerificationCert}

aws iot register-ca-certificate --ca-certificate "file://${CAcert}" --verification-certificate "file://${VerificationCert}" --set-as-active --allow-auto-registration
