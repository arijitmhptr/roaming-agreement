const express = require('express');
const app = express();
require('dotenv').config();
const registerrouter = require('./route/register');
const agreementrouter = require('./route/agreement');

const port = process.env.port || 4000;

app.use(express.json());

app.use('/api/users', registerrouter);

app.use('/api/agreement', agreementrouter);

// Connect to the port
const server = app.listen(port, () => console.log(`Server running on port: ${port}`));

// Handle unhandled promise rejections
process.on('unhandledRejection',(err,promise) => { 
    console.log(`Error: ${err.message}`);
    // Closer server & exit process
    server.close(() => process.exit(1));
});