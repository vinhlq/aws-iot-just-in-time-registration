#!/bin/sh

set -e

Usage="Usage:  $0 <CA key path input> <CA cert path input> [registration code] [verification key output] [verification csr output] [verification cert output] [email] [common name]"

Algo=$1

CAKey=$2
if [ -z ${CAKey} ]
then
    printf "\n\n${Usage}\n\n"
    exit 1
fi

CAcert=$3
if [ -z ${CAcert} ]
then
    printf "\n\n${Usage}\n\n"
    exit 1
fi

RegistrationCode=$4
if [ -z ${RegistrationCode} ]
then
    printf "\n\n${Usage}\n\n"
    exit 1
fi

VerificationKey=$5
[ -z ${VerificationKey} ] && VerificationKey="ecc-verificationCert.key"

VerificationCsr=$6
[ -z ${VerificationCsr} ] && VerificationCsr="ecc-verificationCert.csr"

VerificationCert=$7
[ -z ${VerificationCert} ] && VerificationCert="ecc-verificationCert.crt"

Email=$8
[ -z ${Email} ] && Email="vinhlq@mht.vn"




if [ ${Algo} == "ecc" ]
then
    openssl ecparam -name prime256v1 -genkey -noout -out "${VerificationKey}"
elif [ ${Algo} == "rsa" ]
then
    openssl genrsa -out ${VerificationKey} 2048
else
    echo "Invalid encryption type"
fi

openssl req -new -key "${VerificationKey}" -out "${VerificationCsr}"  \
        -subj "/CN=${RegistrationCode}/emailAddress=${Email}/C=VN/ST=Hanoi/L=Hanoi/O=Minh Ha Technology/OU=MH"

openssl x509 -req -in "${VerificationCsr}"   \
        -CA "${CAcert}"   \
        -CAkey "${CAKey}" -CAcreateserial \
        -out "${VerificationCert}"    \
        -days 36500 -sha256
