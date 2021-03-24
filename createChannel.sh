export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/crypto-config/ordererOrganizations/verizon.com/orderers/orderer.verizon.com/msp/tlscacerts/tls-localhost-7054-ca-verizon-com.pem

export VERIZON_CA=${PWD}/crypto-config/peerOrganizations/verizon.com/peers/peer0.verizon.com/tls/ca.crt
export VODAFONE_CA=${PWD}/crypto-config/peerOrganizations/vodafone.com/peers/peer0.vodafone.com/tls/ca.crt
export AIRTEL_CA=${PWD}/crypto-config/peerOrganizations/airtel.com/peers/peer0.airtel.com/tls/ca.crt

export FABRIC_CFG_PATH=${PWD}/config/

export CHANNEL_NAME="contractchannel"


setGlobalsForVerizon(){
    export CORE_PEER_LOCALMSPID="VerizonMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$VERIZON_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/verizon.com/users/Admin@verizon.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

setGlobalsForVodafone(){
    export CORE_PEER_LOCALMSPID="VodafoneMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$VODAFONE_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/vodafone.com/users/Admin@vodafone.com/msp
    export CORE_PEER_ADDRESS=localhost:9051
}

setGlobalsForAirtel(){
    export CORE_PEER_LOCALMSPID="AirtelMSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$AIRTEL_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/crypto-config/peerOrganizations/airtel.com/users/Admin@airtel.com/msp
    export CORE_PEER_ADDRESS=localhost:11051
}

createChannel(){
    
    setGlobalsForVerizon
    
    peer channel create -o localhost:7050 -c $CHANNEL_NAME \
    --ordererTLSHostnameOverride orderer.verizon.com \
    -f ./channel/${CHANNEL_NAME}.tx --outputBlock ./channel/${CHANNEL_NAME}.block \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
}

joinChannel(){
    
    setGlobalsForVerizon
    peer channel join -b ./channel/$CHANNEL_NAME.block
    
    setGlobalsForVodafone
    peer channel join -b ./channel/$CHANNEL_NAME.block

    setGlobalsForAirtel
    peer channel join -b ./channel/$CHANNEL_NAME.block
}

updateAnchorPeers(){

    setGlobalsForVerizon
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.verizon.com -c $CHANNEL_NAME -f ./channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
    setGlobalsForVodafone
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.verizon.com -c $CHANNEL_NAME -f ./channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
    setGlobalsForAirtel
    peer channel update -o localhost:7050 --ordererTLSHostnameOverride orderer.verizon.com -c $CHANNEL_NAME -f ./channel/${CORE_PEER_LOCALMSPID}anchors.tx --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA
    
    echo "------------------------- Channel created, joined and updated -------"
}

createChannel
joinChannel
updateAnchorPeers