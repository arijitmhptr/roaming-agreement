const { Wallets } = require('fabric-network');
const fabricCA = require('fabric-ca-client');
const { getCCP, getCAurl, getWallet } = require('../middleware/connection');
const { enrollAdmin } = require('./enrollAdmin');

module.exports.registerUser = async(req, res) => {

    try{
    const org = req.body.org;
    const username = req.body.username;

    console.log('Organization: ', org);
    console.log('User Name: ', username);

    let ccp = await getCCP(org);

    const caURL = await getCAurl(org, ccp);
    const ca = new fabricCA(caURL);

    const walletPath = await getWallet(org);
    const wallet = await Wallets.newFileSystemWallet(walletPath);

    const user = await wallet.get(username);


    if(user) {
        console.log(`An identity for the user ${username} already exist`);
        var response = {
            success: true,
            message: "Duplicate User"
        }
        return res.status(201).json(response);
    }
    else {
        console.log('Username does not exist');
    }

    let adminIdentity = await wallet.get('admin');
    if(!adminIdentity) {
        console.log('Admin identity does not exist');
        await enrollAdmin(org,ccp);
        adminIdentity = await wallet.get('admin');
    }
    else {
        console.log('Admin identity is already present');
    }

    // build a user object for authenticating with the CA
    const provider = wallet.getProviderRegistry().getProvider(adminIdentity.type);
    
    const adminUser = await provider.getUserContext(adminIdentity, 'admin');
    // console.log('Admin : ', adminUser);

    // Register the user, enroll the user, and import the new identity into the wallet.
    const secret = await ca.register({
                enrollmentID: username, 
                role: 'client' 
                }, adminUser);

    const enroll = await ca.enroll({enrollmentID: username, enrollmentSecret: secret});

    // const secret = await ca.register({ enrollmentID: username, role: 'client' }, adminUser);

    // const enrollment = await ca.enroll({ enrollmentID: username, enrollmentSecret: secret });


    let x509identity;

    if(org == "Verizon") {

        console.log('Create Verizon user');

        x509identity = {
            credentials:{
                certificate: enroll.certificate,
                privateKey: enroll.key.toBytes(),
            },
            mspId: 'VerizonMSP',
            type: 'X.509'
        };
    }
    else if(org == "Vodafone") {

        console.log('Create Verizon user');

        x509identity = {
            credentials:{
                certificate: enroll.certificate,
                privateKey: enroll.key.toBytes(),
            },
            mspId: 'VodafoneMSP',
            type: 'X.509'
        };
    }
    if(org == "Airtel") {

        console.log('Create Verizon user');

        x509identity = {
            credentials:{
                certificate: enroll.certificate,
                privateKey: enroll.key.toBytes(),
            },
            mspId: 'AirtelMSP',
            type: 'X.509'
        };
    }
    
    await wallet.put(username, x509identity);

    console.log(`Successfully registered and enrolled user ${username} and imported it into the wallet`);
    
    var response = {
        success: true,
        message: username + ' enrolled Successfully',
    };

    res.status(201).json(response);
    }
    catch(error) {

        var response = {
        success: false,
        message: error.message,};
        
        res.status(201).json(response);
    }
};