const { Gateway, Wallets } = require('fabric-network');
const { getCCP, getWallet } = require('../middleware/connection');
const { registerUser } = require('./register');

module.exports.queryAgreements = async(req, res) => {

    try {

        let response, result, identity;

        const username = req.body.username;
        const org = req.body.org;
        const channel = req.body.channel;
        const chaincode = req.body.chaincode;
        // const fcn = req.body.fcn;

        const ccp = await getCCP(org);

        const walletPath = await getWallet(org);
        const wallet = await Wallets.newFileSystemWallet(walletPath);

        identity = await wallet.get(username);

        if(!identity) {

            console.log(`An identity for the user ${username} does not exist in the wallet, Register the user first`);
            response = {
                success: true,
                message: 'Kindly register the user: ' + username,
                uri: 'http://localhost:3000/api/users'
            };
        
        }
        else {

        console.log('User is present');
        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccp, { wallet, identity: username, discovery: { enabled: true, asLocalhost: true } });
    
        // Get the network (channel) our contract is deployed to.
        console.log(`Channel name ... ${channel}`);
        const network = await gateway.getNetwork(channel);
        console.log('channel found');

        console.log(`Chaincode name ... ${chaincode}`);
        const contract = network.getContract(chaincode);
        console.log('chaincode found');

        const result = await contract.evaluateTransaction('GetAllAgreement');

        console.log(result);
        // result = JSON.parse(result.toString());

        response = {
            success: true,
            message: result,
        };
        
        // Disconnect from the gateway.
        await gateway.disconnect();
    }

    res.status(201).json(response);

    }
    catch(error) {

        console.log(error);

        response = {
            success: false,
            message: error.message,
        };

        // disconnect from the network
        await gateway.disconnect();

        res.status(401).json(response);
    }
}
