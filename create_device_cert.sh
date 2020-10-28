#!/bin/sh

set -e

Usage="Usage:  $0 <CA key path output> <CA cert path output> <device key path output> <device cert path output> [device cert signing path output] [email] [common name]"

Algo=$1

CAKey=$2
if [ -z ${CAKey} ]
then
    printf 
    exit 1
fi

CAcert=$3
if [ -z ${CAcert} ]
then
    printf "\n\n${Usage}\n\n"
    exit 1
fi

DevicePrivateKey=$4
if [ -z ${DevicePrivateKey} ]
then
    printf "\n\n${Usage}\n\n"
    exit 1
fi

DeviceCert=$5
if [ -z ${DeviceCert} ]
then
    printf "\n\n${Usage}\n\n"
    exit 1
fi

DeviceCertSigningRequest=$6
[ -z ${DeviceCertSigningRequest} ] && DeviceCertSigningRequest="ecc-device-verificationCert.crt"

Email=$7
[ -z ${Email} ] && Email="vinhlq@mht.vn"

CommonName=$8
[ -z ${CommonName} ] && CommonName="www.mht.vn"





if [ ${Algo} == "ecc" ]
then
    openssl ecparam -name prime256v1 -genkey -noout -out ${DevicePrivateKey}
elif [ ${Algo} == "rsa" ]
then
    openssl genrsa -out ${DevicePrivateKey} 2048
else
    echo "Invalid encryption type"
fi

openssl req -new -key ${DevicePrivateKey}   \
                -out ${DeviceCertSigningRequest}    \
                -subj "/CN=${CommonName}/emailAddress=${Email}/C=VN/ST=Hanoi/L=Hanoi/O=Minh Ha Technology/OU=MH"
                
openssl x509 -req -in ${DeviceCertSigningRequest} -CA ${CAcert} -CAkey ${CAKey} -CAcreateserial -out ${DeviceCert} -days 36500 -sha256
