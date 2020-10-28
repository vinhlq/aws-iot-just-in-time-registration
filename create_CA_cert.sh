#!/bin/sh

set -e

Algo=$1

CAKey=$2
if [ -z ${CAKey} ]
then
    printf "\n\nUsage:  $0 <CA key path output> <CA cert path output> [email] [common name]\n\n"
    exit 1
fi

CAcert=$3
if [ -z ${CAcert} ]
then
    printf "\n\nUsage:  $0 <CA key path output> <CA cert path output> [email] [common name]\n\n"
    exit 1
fi

Email=$4
[ -z ${Email} ] && Email="vinhlq@mht.vn"
CommonName=$5
[ -z ${CommonName} ] && CommonName="www.mht.vn"





if [ ${Algo} == "ecc" ]
then
    openssl ecparam -name prime256v1 -genkey -noout -out ${CAKey}
elif [ ${Algo} == "rsa" ]
then
    openssl genrsa -out ${CAKey} 2048
else
    echo "Invalid encryption type"
fi

openssl req -x509 -new -nodes -key ${CAKey} -sha256 -days 36500 -out ${CAcert} -subj "/CN=${CommonName}/emailAddress=${Email}/C=VN/ST=Hanoi/L=Hanoi/O=Minh Ha Technology/OU=MH"
