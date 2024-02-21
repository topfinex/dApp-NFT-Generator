const Web3 = require('web3');
const { v4: uuidv4 } = require('uuid');

// Initialize Web3 with provider (e.g., Infura)
const web3 = new Web3('YOUR_INFURA_ENDPOINT');

// ABI and contract address of your NFT contract
const contractABI = []; // Your contract's ABI
const contractAddress = 'YOUR_CONTRACT_ADDRESS';

// Account with which you deploy the contract
const deployerAddress = 'YOUR_DEPLOYER_ADDRESS';
const privateKey = 'YOUR_PRIVATE_KEY'; // Private key of the deployer address

// Create contract instance
const nftContract = new web3.eth.Contract(contractABI, contractAddress);

// Function to mint NFT
async function mintNFT(tokenURI) {
    try {
        // Generate a unique token ID
        const tokenId = uuidv4();

        // Send transaction to mint NFT
        const result = await nftContract.methods.mintNFT(deployerAddress, tokenId, tokenURI).send({ from: deployerAddress, gas: 2000000 });

        console.log('NFT minted successfully. Transaction hash:', result.transactionHash);
    } catch (error) {
        console.error('Error minting NFT:', error);
    }
}

// Example usage
const tokenURI = 'https://topfinex.com/metadata/token123.json';
mintNFT(tokenURI);
