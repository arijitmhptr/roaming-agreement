export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/crypto-config/ordererOrganizations/verizon.com/orderers/orderer.verizon.com/msp/tlscacerts/tls-localhost-7054-ca-verizon-com.pem

export VERIZON_CA=${PWD}/crypto-config/peerOrganizations/verizon.com/peers/peer0.verizon.com/tls/ca.crt
export VODAFONE_CA=${PWD}/crypto-config/peerOrganizations/vodafone.com/peers/peer0.vodafone.com/tls/ca.crt
export AIRTEL_CA=${PWD}/crypto-config/peerOrganizations/airtel.com/peers/peer0.airtel.com/tls/ca.crt

export FABRIC_CFG_PATH=${PWD}/config/

export CHANNEL_NAME="contractchannel"
export CC_RUNTIME_LANGUAGE="golang"
export VERSION="1"
export CC_SRC_PATH="./chaincode/"
export CC_NAME="agreement"

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

presetup() {
    echo Vendoring Go dependencies ...
    pushd ./chaincode/
    GO111MODULE=on go mod tidy
    GO111MODULE=on go mod vendor
    popd
    echo Finished vendoring Go dependencies
}

packageChaincode(){

    rm -rf ${CC_NAME}.tar.gz
    setGlobalsForVerizon
    peer lifecycle chaincode package ./chaincode/${CC_NAME}.tar.gz --path ${CC_SRC_PATH} --lang ${CC_RUNTIME_LANGUAGE} --label ${CC_NAME}_${VERSION}
    echo "===================== Chaincode is packaged on peer0.Verizon ===================== "
}

installChaincode(){

    setGlobalsForVerizon
    peer lifecycle chaincode install ./chaincode/${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.Verizon ===================== "
    
    setGlobalsForVodafone
    peer lifecycle chaincode install ./chaincode/${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.Vodafone ===================== "

    setGlobalsForAirtel
    peer lifecycle chaincode install ./chaincode/${CC_NAME}.tar.gz
    echo "===================== Chaincode is installed on peer0.Airtel ===================== "
}

queryInstalled(){

    setGlobalsForVerizon
    peer lifecycle chaincode queryinstalled >&log.txt
    cat log.txt
    PACKAGE_ID=$(sed -n "/${CC_NAME}_${VERSION}/{s/^Package ID: //; s/, Label:.*$//; p;}" log.txt)
    echo PackageID is ${PACKAGE_ID}
    echo "===================== Query installed successful on peer0.Verizon on channel ===================== "
}

approveForVerizon(){

    setGlobalsForVerizon

    peer lifecycle chaincode approveformyorg -o localhost:7050  \
    --ordererTLSHostnameOverride orderer.verizon.com \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME --name ${CC_NAME} \
    --version ${VERSION} --init-required --package-id ${PACKAGE_ID} --sequence ${VERSION}

    echo "===================== chaincode approved from Verizon ===================== "
}

checkCommitReadyness(){

    setGlobalsForVerizon

    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
    --name ${CC_NAME} --version ${VERSION} --sequence ${VERSION} --output json --init-required

    echo "===================== checking commit readyness from Verizon ===================== "
}

approveForVodafone() {

    setGlobalsForVodafone

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.verizon.com \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME --name ${CC_NAME} \
    --version ${VERSION} --init-required --package-id ${PACKAGE_ID} --sequence ${VERSION}

    echo "===================== chaincode approved from Vodafone ===================== "
}

checkCommitReadyness(){
    
    setGlobalsForVodafone

    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
    --peerAddresses localhost:7051 --tlsRootCertFiles $VERIZON_CA \
    --name ${CC_NAME} --version ${VERSION} \
    --sequence ${VERSION} --output json --init-required

    echo "===================== checking commit readyness from Vodafone ===================== "
}

approveForAirtel() {

    setGlobalsForAirtel

    peer lifecycle chaincode approveformyorg -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.verizon.com \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME --name ${CC_NAME} \
    --version ${VERSION} --init-required --package-id ${PACKAGE_ID} --sequence ${VERSION}

    echo "===================== chaincode approved from Airtel ===================== "
}

checkCommitReadyness(){
    
    setGlobalsForAirtel

    peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_NAME \
    --peerAddresses localhost:7051 --tlsRootCertFiles $VERIZON_CA \
    --name ${CC_NAME} --version ${VERSION} \
    --sequence ${VERSION} --output json --init-required

    echo "===================== checking commit readyness from Airtel ===================== "
}

commitChaincodeDefination(){

    setGlobalsForVerizon

    peer lifecycle chaincode commit -o localhost:7050 \
    --ordererTLSHostnameOverride orderer.verizon.com \
    --tls $CORE_PEER_TLS_ENABLED  --cafile $ORDERER_CA \
    --channelID $CHANNEL_NAME --name ${CC_NAME} \
    --peerAddresses localhost:7051 --tlsRootCertFiles $VERIZON_CA \
    --peerAddresses localhost:9051 --tlsRootCertFiles $VODAFONE_CA \
    --peerAddresses localhost:11051 --tlsRootCertFiles $AIRTEL_CA \
    --version ${VERSION} --sequence ${VERSION} \
    --init-required
   
   echo "===================== Chaincode Defination commited on peer0-Verizon, peer0-Vodafone and peer0-Airtel ===================== "
}

queryCommitted(){

    setGlobalsForVerizon

    peer lifecycle chaincode querycommitted --channelID $CHANNEL_NAME --name ${CC_NAME}
   
}

chaincodeInvokeInit(){

    setGlobalsForVerizon

    peer chaincode invoke -o localhost:7050 --ordererTLSHostnameOverride orderer.verizon.com \
    --tls $CORE_PEER_TLS_ENABLED --cafile $ORDERER_CA -C $CHANNEL_NAME -n ${CC_NAME} \
    --peerAddresses localhost:7051 --tlsRootCertFiles $VERIZON_CA \
    --peerAddresses localhost:9051 --tlsRootCertFiles $VODAFONE_CA \
    --peerAddresses localhost:11051 --tlsRootCertFiles $AIRTEL_CA \
    --isInit -c '{"function":"InitLedger","Args":[]}'
    
}

chaincodeInvoke(){   

    setGlobalsForVerizon

    ## Create Car
    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.verizon.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME}  \
        --peerAddresses localhost:7051 --tlsRootCertFiles $VERIZON_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $VODAFONE_CA \
        -c '{"function": "CreateAgreement","Args":["VER28", "Verizon", "Idea"]}'
    
    ## Change land owner
    # peer chaincode invoke -o localhost:7050 \
    #     --ordererTLSHostnameOverride orderer.verizon.com \
    #     --tls $CORE_PEER_TLS_ENABLED \
    #     --cafile $ORDERER_CA \
    #     -C $CHANNEL_NAME -n ${CC_NAME}  \
    #     --peerAddresses localhost:7051 --tlsRootCertFiles $VERIZON_CA \
    #     --peerAddresses localhost:8051 --tlsRootCertFiles $VODAFONE_CA  \
    #     -c '{"function": "changeOwner","Args":["LAND3", "Sandip"]}'

    echo "===================== Chaincode Invoke ===================== "
}

chaincodeQuery(){

    setGlobalsForVerizon

    # Query all Cars
    # peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function":"queryallLand","Args":[]}'
    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"function":"GetAllAgreement","Args":[]}'
}

presetup
packageChaincode
installChaincode
queryInstalled
approveForVerizon
checkCommitReadyness
approveForVodafone
checkCommitReadyness
approveForAirtel
checkCommitReadyness
commitChaincodeDefination
queryCommitted
chaincodeInvokeInit
# chaincodeInvoke
# chaincodeQuery
