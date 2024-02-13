const IPFSClient = require('ipfs-http-client');
const Web3 = require('web3');
const MyNFTContract = require('./build/contracts/MyNFT.json');

// IPFS configuration
const ipfs = new IPFSClient({ host: 'ipfs.infura.io', port: 5001, protocol: 'https' });

// Ethereum configuration
const web3 = new Web3('YOUR_ETH_PROVIDER_URL'); // Replace with your Ethereum provider URL
const contractAddress = 'YOUR_CONTRACT_ADDRESS'; // Replace with your deployed contract address

// Metadata
const metadata = {
    name: 'My NFT',
    description: 'This is a unique digital artwork.',
    image: 'ipfs://<IPFS_HASH>/image.jpg',
    attributes: [
        {
            trait_type: 'Color',
            value: 'Blue'
        },
        {
            trait_type: 'Edition',
            value: '1 of 10'
        }
    ]
};

async function uploadMetadataToIPFS(metadata) {
    const metadataBuffer = Buffer.from(JSON.stringify(metadata));
    const { cid } = await ipfs.add(metadataBuffer);
    return `ipfs://${cid.toString()}`;
}

async function mintNFT(ipfsURI) {
    const accounts = await web3.eth.getAccounts();
    const myNFTContract = new web3.eth.Contract(MyNFTContract.abi, contractAddress);
    await myNFTContract.methods.mintNFT(accounts[0], ipfsURI).send({ from: accounts[0] });
    console.log('NFT minted successfully!');
}

async function main() {
    try {
        const ipfsURI = await uploadMetadataToIPFS(metadata);
        console.log('Metadata uploaded to IPFS:', ipfsURI);
        await mintNFT(ipfsURI);
    } catch (error) {
        console.error('Error:', error);
    }
}

main();
