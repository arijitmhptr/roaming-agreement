# roaming-agreement
roaming agreement implemented in HLF

1. Navigate to CA folder and up all the FabricCA container
2. Execute the create-certificate-with-ca.sh script to create the certificates for all Orderers and Peers
3. Bring down the FabricCA container
4. Execute start.sh script - It will bootstrap the HLF network
5. Navigate to the backend folder and execute the below command to install all the modules and run the backend server
    npm install
    npm start
