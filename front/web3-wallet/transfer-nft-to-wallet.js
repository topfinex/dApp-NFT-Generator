const Web3 = require('web3');
const { createAlchemyWeb3 } = require('@alch/alchemy-web3');
const contractABI = require('./contractABI.json'); // Assuming you have the ABI saved in a JSON file

// Initialize Web3 with your preferred provider (e.g., Alchemy)
const web3 = createAlchemyWeb3('YOUR_ALCHEMY_API_KEY');

// Set the contract address
const contractAddress = 'YOUR_NFT_CONTRACT_ADDRESS';

// Create contract instance
const nftContract = new web3.eth.Contract(contractABI, contractAddress);

// Account with which you want to send the NFT
const fromAddress = 'YOUR_SENDER_ADDRESS';

// Recipient address
const toAddress = 'RECIPIENT_ADDRESS';

// Token ID of the NFT you want to send
const tokenId = 'NFT_TOKEN_ID';

// Function to send NFT
async function sendNFT() {
    try {
        // Get the transaction count to use as the nonce
        const nonce = await web3.eth.getTransactionCount(fromAddress, 'latest');

        // Encode the transfer function with the recipient and token ID
        const data = nftContract.methods.safeTransferFrom(fromAddress, toAddress, tokenId).encodeABI();

        // Build the transaction object
        const txObject = {
            nonce: nonce,
            from: fromAddress,
            to: contractAddress,
            gas: web3.utils.toHex(800000),
            gasPrice: web3.utils.toHex(web3.utils.toWei('10', 'gwei')),
            data: data
        };

        // Sign the transaction with your private key
        const signedTx = await web3.eth.accounts.signTransaction(txObject, 'YOUR_PRIVATE_KEY');

        // Send the signed transaction
        const tx = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
        console.log('Transaction hash:', tx.transactionHash);
    } catch (error) {
        console.error('Error sending NFT:', error);
    }
}

// Call the function to send the NFT
sendNFT();