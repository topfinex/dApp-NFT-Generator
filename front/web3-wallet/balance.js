const Web3 = require('web3');

// Infura endpoint (replace with your own Infura endpoint)
const infuraEndpoint = 'https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID';

// Initialize Web3 with the Infura provider
const web3 = new Web3(new Web3.providers.HttpProvider(infuraEndpoint));

// Ethereum account address for which you want to get the balance
const accountAddress = '0xYOUR_ACCOUNT_ADDRESS';

// Function to get balance
async function getBalance() {
    try {
        // Get balance in wei
        const balanceWei = await web3.eth.getBalance(accountAddress);

        // Convert balance from wei to Ether
        const balanceEther = web3.utils.fromWei(balanceWei, 'ether');

        console.log(`Balance of ${accountAddress}: ${balanceEther} ETH`);
    } catch (error) {
        console.error('Error:', error);
    }
}

// Call the function to get the balance
getBalance();
