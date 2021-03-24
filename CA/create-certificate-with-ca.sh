createcertificatesForVerizon() {

  mkdir -p ../crypto-config/peerOrganizations/verizon.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/verizon.com/
   
  echo "Enroll the Verizon-CA admin"
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.verizon.com --tls.certfiles ${PWD}/fabric-ca/verizon/tls-cert.pem
   
  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-verizon-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-verizon-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-verizon-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-verizon-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/verizon.com/msp/config.yaml


  echo "Register peer0"
  fabric-ca-client register --caname ca.verizon.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/verizon/tls-cert.pem

  echo "Register user"
  fabric-ca-client register --caname ca.verizon.com --id.name user --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/verizon/tls-cert.pem

  echo "Register the org admin"
  fabric-ca-client register --caname ca.verizon.com --id.name Admin --id.secret org1adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/verizon/tls-cert.pem

  mkdir -p ../crypto-config/peerOrganizations/verizon.com/peers/peer0.verizon.com

  echo "## Generate the peer0 msp"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.verizon.com -M ${PWD}/../crypto-config/peerOrganizations/verizon.com/peers/peer0.verizon.com/msp --csr.hosts peer0.verizon.com --tls.certfiles ${PWD}/fabric-ca/verizon/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/verizon.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/verizon.com/peers/peer0.verizon.com/msp/config.yaml

  echo "## Generate the peer0-tls certificates"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca.verizon.com -M ${PWD}/../crypto-config/peerOrganizations/verizon.com/peers/peer0.verizon.com/tls --enrollment.profile tls --csr.hosts peer0.verizon.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/verizon/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/verizon.com/peers/peer0.verizon.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/verizon.com/peers/peer0.verizon.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/verizon.com/peers/peer0.verizon.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/verizon.com/peers/peer0.verizon.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/verizon.com/peers/peer0.verizon.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/verizon.com/peers/peer0.verizon.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/verizon.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/verizon.com/peers/peer0.verizon.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/verizon.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/verizon.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/verizon.com/peers/peer0.verizon.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/verizon.com/tlsca/tls-localhost-7054-ca-verizon-com.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/verizon.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/verizon.com/peers/peer0.verizon.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/verizon.com/ca/localhost-7054-ca-verizon-com.pem

  # --------------------------------------------------------------------------------------------------

  # mkdir -p ../crypto-config/peerOrganizations/verizon.com/users
  mkdir -p ../crypto-config/peerOrganizations/verizon.com/users/User@verizon.com

  echo "## Generate the user msp"
  fabric-ca-client enroll -u https://user:user1pw@localhost:7054 --caname ca.verizon.com -M ${PWD}/../crypto-config/peerOrganizations/verizon.com/users/User@verizon.com/msp --tls.certfiles ${PWD}/fabric-ca/verizon/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/verizon.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/verizon.com/users/User@verizon.com/msp/config.yaml

  mkdir -p ../crypto-config/peerOrganizations/verizon.com/users/Admin@verizon.com

  echo
  echo "## Generate the org admin msp"
  echo
  fabric-ca-client enroll -u https://Admin:org1adminpw@localhost:7054 --caname ca.verizon.com -M ${PWD}/../crypto-config/peerOrganizations/verizon.com/users/Admin@verizon.com/msp --tls.certfiles ${PWD}/fabric-ca/verizon/tls-cert.pem

  cp ${PWD}/../crypto-config/peerOrganizations/verizon.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/verizon.com/users/Admin@verizon.com/msp/config.yaml

}

createCertificatesForVodafone() {

  mkdir -p /../crypto-config/peerOrganizations/vodafone.com/
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/vodafone.com/

  echo "Enroll the Vodafone CA admin"
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca.vodafone.com --tls.certfiles ${PWD}/fabric-ca/vodafone/tls-cert.pem
   
  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-vodafone-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-vodafone-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-vodafone-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-vodafone-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/vodafone.com/msp/config.yaml

  echo "Register peer0"
  fabric-ca-client register --caname ca.vodafone.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/vodafone/tls-cert.pem
   
  echo "Register user"   
  fabric-ca-client register --caname ca.vodafone.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/vodafone/tls-cert.pem
  
  echo "Register the org admin"
  fabric-ca-client register --caname ca.vodafone.com --id.name org2admin --id.secret org2adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/vodafone/tls-cert.pem
   
  mkdir -p ../crypto-config/peerOrganizations/vodafone.com/peers/peer0.vodafone.com

  # --------------------------------------------------------------
  # Peer 0
  echo "## Generate the peer0 msp"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.vodafone.com -M ${PWD}/../crypto-config/peerOrganizations/vodafone.com/peers/peer0.vodafone.com/msp --csr.hosts peer0.vodafone.com --tls.certfiles ${PWD}/fabric-ca/vodafone/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/vodafone.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/vodafone.com/peers/peer0.vodafone.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
   
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca.vodafone.com -M ${PWD}/../crypto-config/peerOrganizations/vodafone.com/peers/peer0.vodafone.com/tls --enrollment.profile tls --csr.hosts peer0.vodafone.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/vodafone/tls-cert.pem
   

  cp ${PWD}/../crypto-config/peerOrganizations/vodafone.com/peers/peer0.vodafone.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/vodafone.com/peers/peer0.vodafone.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/vodafone.com/peers/peer0.vodafone.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/vodafone.com/peers/peer0.vodafone.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/vodafone.com/peers/peer0.vodafone.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/vodafone.com/peers/peer0.vodafone.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/vodafone.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/vodafone.com/peers/peer0.vodafone.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/vodafone.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/vodafone.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/vodafone.com/peers/peer0.vodafone.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/vodafone.com/tlsca/tls-localhost-8054-ca-vodafone-com.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/vodafone.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/vodafone.com/peers/peer0.vodafone.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/vodafone.com/ca/localhost-8054-ca-vodafone-com.pem

  # --------------------------------------------------------------------------------
 
  # mkdir -p ../crypto-config/peerOrganizations/vodafone.com/users
  mkdir -p ../crypto-config/peerOrganizations/vodafone.com/users/User@vodafone.com

  echo "## Generate the user msp"
   
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca.vodafone.com -M ${PWD}/../crypto-config/peerOrganizations/vodafone.com/users/User1@vodafone.com/msp --tls.certfiles ${PWD}/fabric-ca/vodafone/tls-cert.pem
   
  cp ${PWD}/../crypto-config/peerOrganizations/vodafone.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/vodafone.com/users/User@vodafone.com/msp/config.yaml

  mkdir -p ../crypto-config/peerOrganizations/vodafone.com/users/Admin@vodafone.com

  echo "## Generate the org admin msp"
   
  fabric-ca-client enroll -u https://org2admin:org2adminpw@localhost:8054 --caname ca.vodafone.com -M ${PWD}/../crypto-config/peerOrganizations/vodafone.com/users/Admin@vodafone.com/msp --tls.certfiles ${PWD}/fabric-ca/vodafone/tls-cert.pem
  
  cp ${PWD}/../crypto-config/peerOrganizations/vodafone.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/vodafone.com/users/Admin@vodafone.com/msp/config.yaml
}

createCertificatesForAirtel() {
  echo
  echo "Enroll the CA admin"
  echo
  mkdir -p /../crypto-config/peerOrganizations/airtel.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/peerOrganizations/airtel.com/

  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca.airtel.com --tls.certfiles ${PWD}/fabric-ca/airtel/tls-cert.pem
   

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-airtel-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-airtel-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-airtel-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-airtel-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/peerOrganizations/airtel.com/msp/config.yaml

  echo "Register peer0"   
  fabric-ca-client register --caname ca.airtel.com --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/fabric-ca/airtel/tls-cert.pem
  
  echo "Register user"  
  fabric-ca-client register --caname ca.airtel.com --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/fabric-ca/airtel/tls-cert.pem
  
  echo "Register the org admin"
  fabric-ca-client register --caname ca.airtel.com --id.name org3admin --id.secret org3adminpw --id.type admin --tls.certfiles ${PWD}/fabric-ca/airtel/tls-cert.pem
  
  mkdir -p ../crypto-config/peerOrganizations/airtel.com/peers
  mkdir -p ../crypto-config/peerOrganizations/airtel.com/peers/peer0.airtel.com

  # --------------------------------------------------------------
  echo "## Generate the peer0 msp"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca.airtel.com -M ${PWD}/../crypto-config/peerOrganizations/airtel.com/peers/peer0.airtel.com/msp --csr.hosts peer0.airtel.com --tls.certfiles ${PWD}/fabric-ca/airtel/tls-cert.pem
  
  cp ${PWD}/../crypto-config/peerOrganizations/airtel.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/airtel.com/peers/peer0.airtel.com/msp/config.yaml

  echo "## Generate the peer0-tls certificates"
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca.airtel.com -M ${PWD}/../crypto-config/peerOrganizations/airtel.com/peers/peer0.airtel.com/tls --enrollment.profile tls --csr.hosts peer0.airtel.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/airtel/tls-cert.pem
  
  cp ${PWD}/../crypto-config/peerOrganizations/airtel.com/peers/peer0.airtel.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/airtel.com/peers/peer0.airtel.com/tls/ca.crt
  cp ${PWD}/../crypto-config/peerOrganizations/airtel.com/peers/peer0.airtel.com/tls/signcerts/* ${PWD}/../crypto-config/peerOrganizations/airtel.com/peers/peer0.airtel.com/tls/server.crt
  cp ${PWD}/../crypto-config/peerOrganizations/airtel.com/peers/peer0.airtel.com/tls/keystore/* ${PWD}/../crypto-config/peerOrganizations/airtel.com/peers/peer0.airtel.com/tls/server.key

  mkdir ${PWD}/../crypto-config/peerOrganizations/airtel.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/peerOrganizations/airtel.com/peers/peer0.airtel.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/airtel.com/msp/tlscacerts/ca.crt

  mkdir ${PWD}/../crypto-config/peerOrganizations/airtel.com/tlsca
  cp ${PWD}/../crypto-config/peerOrganizations/airtel.com/peers/peer0.airtel.com/tls/tlscacerts/* ${PWD}/../crypto-config/peerOrganizations/airtel.com/tlsca/tls-localhost-9054-ca-airtel-com.pem

  mkdir ${PWD}/../crypto-config/peerOrganizations/airtel.com/ca
  cp ${PWD}/../crypto-config/peerOrganizations/airtel.com/peers/peer0.airtel.com/msp/cacerts/* ${PWD}/../crypto-config/peerOrganizations/airtel.com/ca/localhost-9054-ca-airtel-com.pem

  # --------------------------------------------------------------------------------

  mkdir -p ../crypto-config/peerOrganizations/airtel.com/users
  mkdir -p ../crypto-config/peerOrganizations/airtel.com/users/User@airtel.com

  echo "## Generate the user msp"
  fabric-ca-client enroll -u https://user1:user1pw@localhost:9054 --caname ca.airtel.com -M ${PWD}/../crypto-config/peerOrganizations/airtel.com/users/User1@airtel.com/msp --tls.certfiles ${PWD}/fabric-ca/airtel/tls-cert.pem
   
  cp ${PWD}/../crypto-config/peerOrganizations/airtel.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/airtel.com/users/User@airtel.com/msp/config.yaml

  mkdir -p ../crypto-config/peerOrganizations/airtel.com/users/Admin@airtel.com

  echo "## Generate the org admin msp"
  fabric-ca-client enroll -u https://org3admin:org3adminpw@localhost:9054 --caname ca.airtel.com -M ${PWD}/../crypto-config/peerOrganizations/airtel.com/users/Admin@airtel.com/msp --tls.certfiles ${PWD}/fabric-ca/airtel/tls-cert.pem
  
  cp ${PWD}/../crypto-config/peerOrganizations/airtel.com/msp/config.yaml ${PWD}/../crypto-config/peerOrganizations/airtel.com/users/Admin@airtel.com/msp/config.yaml
}

createCretificatesForVerizon-Orderer() {

  # Verizon Orderer CA
  mkdir -p ../crypto-config/ordererOrganizations/verizon.com
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/ordererOrganizations/verizon.com

  echo "Enroll the Verizon-CA admin"
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca.verizon.com --tls.certfiles ${PWD}/fabric-ca/verizon/tls-cert.pem
  
  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-verizon-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-verizon-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-verizon-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-verizon-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/ordererOrganizations/verizon.com/msp/config.yaml

  echo "Register orderer"
  fabric-ca-client register --caname ca.verizon.com --id.name orderer --id.secret ordererpw --id.type orderer -u https://admin:adminpw@localhost:7054 --tls.certfiles ${PWD}/fabric-ca/verizon/tls-cert.pem
  
  echo "Register the orderer admin"
  fabric-ca-client register --caname ca.verizon.com --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin -u https://admin:adminpw@localhost:7054 --tls.certfiles ${PWD}/fabric-ca/verizon/tls-cert.pem

  mkdir -p ../crypto-config/ordererOrganizations/verizon.com/orderers/orderer.verizon.com

  echo "## Generate the Verizon orderer msp"
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:7054 --caname ca.verizon.com -M ${PWD}/../crypto-config/ordererOrganizations/verizon.com/orderers/orderer.verizon.com/msp --csr.hosts orderer.verizon.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/verizon/tls-cert.pem
  
  cp ${PWD}/../crypto-config/ordererOrganizations/verizon.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/verizon.com/orderers/orderer.verizon.com/msp/config.yaml

  echo "## Generate the orderer-tls certificates"
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:7054 --caname ca.verizon.com -M ${PWD}/../crypto-config/ordererOrganizations/verizon.com/orderers/orderer.verizon.com/tls --enrollment.profile tls --csr.hosts orderer.verizon.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/verizon/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/verizon.com/orderers/orderer.verizon.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/verizon.com/orderers/orderer.verizon.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/verizon.com/orderers/orderer.verizon.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/verizon.com/orderers/orderer.verizon.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/verizon.com/orderers/orderer.verizon.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/verizon.com/orderers/orderer.verizon.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/verizon.com/orderers/orderer.verizon.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/verizon.com/orderers/orderer.verizon.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/verizon.com/orderers/orderer.verizon.com/msp/tlscacerts/tls-localhost-7054-ca-verizon-com.pem

  mkdir ${PWD}/../crypto-config/ordererOrganizations/verizon.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/verizon.com/orderers/orderer.verizon.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/verizon.com/msp/tlscacerts/tls-localhost-7054-ca-verizon-com.pem

  mkdir -p ../crypto-config/ordererOrganizations/verizon.com/users/Admin@verizon.com

  echo "## Generate the admin msp"
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:7054 --caname ca.verizon.com -M ${PWD}/../crypto-config/ordererOrganizations/verizon.com/users/Admin@verizon.com/msp --tls.certfiles ${PWD}/fabric-ca/verizon/tls-cert.pem
  
  cp ${PWD}/../crypto-config/ordererOrganizations/verizon.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/verizon.com/users/Admin@verizon.com/msp/config.yaml
}

createCretificatesForvodafone-Orderer() {

  # vodafone Orderer CA

  echo "Enroll the vodafone-CA admin"

  mkdir -p ../crypto-config/ordererOrganizations/vodafone.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/ordererOrganizations/vodafone.com

  fabric-ca-client enroll -d -u https://admin:adminpw@localhost:8054 --caname ca.vodafone.com --tls.certfiles ${PWD}/fabric-ca/vodafone/tls-cert.pem
  
  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-vodafone-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-vodafone-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-vodafone-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-vodafone-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/ordererOrganizations/vodafone.com/msp/config.yaml

  echo "Register orderer"
  fabric-ca-client register --caname ca.vodafone.com --id.name orderer --id.secret ordererpw --id.type orderer -u https://admin:adminpw@localhost:8054 --tls.certfiles ${PWD}/fabric-ca/vodafone/tls-cert.pem
  
  echo "Register the orderer admin"
  fabric-ca-client register --caname ca.vodafone.com --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin -u https://admin:adminpw@localhost:8054 --tls.certfiles ${PWD}/fabric-ca/vodafone/tls-cert.pem

  mkdir -p ../crypto-config/ordererOrganizations/vodafone.com/orderers/orderer.vodafone.com

  echo "## Generate the vodafone orderer msp"
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:8054 --caname ca.vodafone.com -M ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/orderers/orderer.vodafone.com/msp --csr.hosts orderer.vodafone.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/vodafone/tls-cert.pem
  
  cp ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/orderers/orderer.vodafone.com/msp/config.yaml

  echo "## Generate the orderer-tls certificates"
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:8054 --caname ca.vodafone.com -M ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/orderers/orderer.vodafone.com/tls --enrollment.profile tls --csr.hosts orderer.vodafone.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/vodafone/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/orderers/orderer.vodafone.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/orderers/orderer.vodafone.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/orderers/orderer.vodafone.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/orderers/orderer.vodafone.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/orderers/orderer.vodafone.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/orderers/orderer.vodafone.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/orderers/orderer.vodafone.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/orderers/orderer.vodafone.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/orderers/orderer.vodafone.com/msp/tlscacerts/tls-localhost-8054-ca-vodafone-com.pem

  mkdir ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/orderers/orderer.vodafone.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/msp/tlscacerts/tls-localhost-8054-ca-vodafone-com.pem

  mkdir -p ../crypto-config/ordererOrganizations/vodafone.com/users/Admin@vodafone.com

  echo
  echo "## Generate the admin msp"
  echo
   
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:8054 --caname ca.vodafone.com -M ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/users/Admin@vodafone.com/msp --tls.certfiles ${PWD}/fabric-ca/vodafone/tls-cert.pem
  
  cp ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/vodafone.com/users/Admin@vodafone.com/msp/config.yaml

}

createCretificatesForairtel-Orderer() {

  # airtel Orderer CA
  
  mkdir -p ../crypto-config/ordererOrganizations/airtel.com
  export FABRIC_CA_CLIENT_HOME=${PWD}/../crypto-config/ordererOrganizations/airtel.com

  echo "Enroll the airtel-CA admin"
  fabric-ca-client enroll -d -u https://admin:adminpw@localhost:9054 --caname ca.airtel.com --tls.certfiles ${PWD}/fabric-ca/airtel/tls-cert.pem
  
  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-airtel-com.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-airtel-com.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-airtel-com.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-airtel-com.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/../crypto-config/ordererOrganizations/airtel.com/msp/config.yaml

  echo "Register orderer"
  fabric-ca-client register --caname ca.airtel.com --id.name orderer --id.secret ordererpw --id.type orderer -u https://admin:adminpw@localhost:9054 --tls.certfiles ${PWD}/fabric-ca/airtel/tls-cert.pem
  
  echo "Register the orderer admin"
  fabric-ca-client register --caname ca.airtel.com --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin -u https://admin:adminpw@localhost:9054 --tls.certfiles ${PWD}/fabric-ca/airtel/tls-cert.pem

  mkdir -p ../crypto-config/ordererOrganizations/airtel.com/orderers/orderer.airtel.com

  echo "## Generate the airtel orderer msp"
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca.airtel.com -M ${PWD}/../crypto-config/ordererOrganizations/airtel.com/orderers/orderer.airtel.com/msp --csr.hosts orderer.airtel.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/airtel/tls-cert.pem
  
  cp ${PWD}/../crypto-config/ordererOrganizations/airtel.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/airtel.com/orderers/orderer.airtel.com/msp/config.yaml

  echo "## Generate the orderer-tls certificates"
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca.airtel.com -M ${PWD}/../crypto-config/ordererOrganizations/airtel.com/orderers/orderer.airtel.com/tls --enrollment.profile tls --csr.hosts orderer.airtel.com --csr.hosts localhost --tls.certfiles ${PWD}/fabric-ca/airtel/tls-cert.pem
   

  cp ${PWD}/../crypto-config/ordererOrganizations/airtel.com/orderers/orderer.airtel.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/airtel.com/orderers/orderer.airtel.com/tls/ca.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/airtel.com/orderers/orderer.airtel.com/tls/signcerts/* ${PWD}/../crypto-config/ordererOrganizations/airtel.com/orderers/orderer.airtel.com/tls/server.crt
  cp ${PWD}/../crypto-config/ordererOrganizations/airtel.com/orderers/orderer.airtel.com/tls/keystore/* ${PWD}/../crypto-config/ordererOrganizations/airtel.com/orderers/orderer.airtel.com/tls/server.key

  mkdir ${PWD}/../crypto-config/ordererOrganizations/airtel.com/orderers/orderer.airtel.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/airtel.com/orderers/orderer.airtel.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/airtel.com/orderers/orderer.airtel.com/msp/tlscacerts/tls-localhost-9054-ca-airtel-com.pem

  mkdir ${PWD}/../crypto-config/ordererOrganizations/airtel.com/msp/tlscacerts
  cp ${PWD}/../crypto-config/ordererOrganizations/airtel.com/orderers/orderer.airtel.com/tls/tlscacerts/* ${PWD}/../crypto-config/ordererOrganizations/airtel.com/msp/tlscacerts/tls-localhost-9054-ca-airtel-com.pem

  mkdir -p ../crypto-config/ordererOrganizations/airtel.com/users/Admin@airtel.com

  echo "## Generate the admin msp"
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:9054 --caname ca.airtel.com -M ${PWD}/../crypto-config/ordererOrganizations/airtel.com/users/Admin@airtel.com/msp --tls.certfiles ${PWD}/fabric-ca/airtel/tls-cert.pem
  
  cp ${PWD}/../crypto-config/ordererOrganizations/airtel.com/msp/config.yaml ${PWD}/../crypto-config/ordererOrganizations/airtel.com/users/Admin@airtel.com/msp/config.yaml
}

sudo rm -rf ../crypto-config

createcertificatesForVerizon
createCertificatesForVodafone
createCertificatesForAirtel

createCretificatesForVerizon-Orderer
createCretificatesForvodafone-Orderer
createCretificatesForairtel-Orderer