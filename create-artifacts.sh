# sudo chmod -R 0755 ./crypto-config
# Delete existing artifacts
# rm -rf ./crypto-config
rm -rf ./channel/*

#Generate Crypto artifactes for organizations
# cryptogen generate --config=./config/crypto-config.yaml --output=./crypto-config/

export SYS_CHANNEL="systemchannel"
export CHANNEL_NAME="contractchannel"

# Generate System Genesis block
echo "#######    Generate System Genesis block  ##########"
configtxgen -profile ContractGenesis -configPath ./config -channelID $SYS_CHANNEL  -outputBlock ./channel/genesis.block

# Generate channel configuration block
echo "#######    Generate channel configuration block  ##########"
configtxgen -profile ContractChannel -configPath ./config -outputCreateChannelTx ./channel/contractchannel.tx -channelID $CHANNEL_NAME

# Generate Anchor peer
echo "#######    Generating anchor peer update for VerizonMSP  ##########"
configtxgen -profile ContractChannel -configPath ./config -outputAnchorPeersUpdate ./channel/VerizonMSPanchors.tx -channelID $CHANNEL_NAME -asOrg Verizon

echo "#######    Generating anchor peer update for VodafoneMSP  ##########"
configtxgen -profile ContractChannel -configPath ./config -outputAnchorPeersUpdate ./channel/VodafoneMSPanchors.tx -channelID $CHANNEL_NAME -asOrg Vodafone

echo "#######    Generating anchor peer update for AirtelMSP  ##########"
configtxgen -profile ContractChannel -configPath ./config -outputAnchorPeersUpdate ./channel/AirtelMSPanchors.tx -channelID $CHANNEL_NAME -asOrg Airtel