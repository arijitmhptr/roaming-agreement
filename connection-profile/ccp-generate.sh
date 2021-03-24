#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ./ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        ./ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=1
P0PORT=7051
CAPORT=7054
PEERPEM=../crypto-config/peerOrganizations/verizon.com/tlsca/tls-localhost-7054-ca-verizon-com.pem
CAPEM=../crypto-config/peerOrganizations/verizon.com/ca/localhost-7054-ca-verizon-com.pem

# echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ./connection-org1.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ./connection-verizon.yaml

ORG=2
P0PORT=9051
CAPORT=8054
PEERPEM=../crypto-config/peerOrganizations/vodafone.com/tlsca/tls-localhost-8054-ca-vodafone-com.pem
CAPEM=../crypto-config/peerOrganizations/vodafone.com/ca/localhost-8054-ca-vodafone-com.pem

# echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ./connection-org2.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ./connection-vodafone.yaml

ORG=3
P0PORT=11051
CAPORT=9054
PEERPEM=../crypto-config/peerOrganizations/airtel.com/tlsca/tls-localhost-9054-ca-airtel-com.pem
CAPEM=../crypto-config/peerOrganizations/airtel.com/ca/localhost-9054-ca-airtel-com.pem

# echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ./connection-org2.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > ./connection-airtel.yaml