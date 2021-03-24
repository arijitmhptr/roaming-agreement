const path = require('path');
const yaml = require('js-yaml');
const fs = require('fs');

module.exports.getCCP = (org) => {
    
    let ccpPath;
        
    if(org == "Verizon") {
        ccpPath = path.resolve(__dirname,'..','..','connection-profile','connection-verizon.yaml');
    }

    if(org == "Vodafone") {
        ccpPath = path.resolve(__dirname,'..','..','connection-profile','connection-vodafone.yaml');
    }

    if(org == "Airtel") {
        ccpPath = path.resolve(__dirname,'..','..','connection-profile','connection-airtel.yaml');
    }

    console.log('CCP : ', ccpPath);
    const ccp = yaml.load(fs.readFileSync(ccpPath, 'utf-8'));

    return ccp;
};

module.exports.getCAurl = (org, ccp) => {

    let caURL;

    if(org == "Verizon") {
        caURL = ccp.certificateAuthorities['ca.verizon.com'].url;
    }
    if(org == "Vodafone") {
        caURL = ccp.certificateAuthorities['ca.vodafone.com'].url;
    }
    if(org == "Airtel") {
        caURL = ccp.certificateAuthorities['ca.airtel.com'].url;
    }
    console.log('CA-url: ', caURL);
    return caURL;
};

module.exports.getWallet = (org) => {

    let walletPath;

    if(org == "Verizon") {
        walletPath = path.join(process.cwd(), 'Verizon-Wallet');
    }

    if(org == "Vodafone") {
        walletPath = path.join(process.cwd(), 'Vodafone-Wallet');
    }

    if(org == "Airtel") {
        walletPath = path.join(process.cwd(), 'Airtel-Wallet');
    }
    return walletPath;
};

// module.exports.getAffiliation = (org) => {

//     let affiliation;

//     if(org == "Verizon") {
//         affiliation = "Verizon.department1";
//     }
//     else {
//         affiliation = null;
//     }

//     return affiliation;
// };

module.exports.getCAinfo = (org, ccp) => {

    let caInfo;

    if(org == "Verizon") {
        caInfo = ccp.certificateAuthorities['ca.verizon.com'];
    }

    if(org == "Vodafone") {
        caInfo = ccp.certificateAuthorities['ca.vodafone.com'];
    }

    if(org == "Airtel") {
        caInfo = ccp.certificateAuthorities['ca.airtel.com'];
    }
    
    return caInfo;
};