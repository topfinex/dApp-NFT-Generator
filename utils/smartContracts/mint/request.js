const MyNFTContract = artifacts.require("MyNFT");

const IPFS_URI = `ipfs://${this.HASH_URI}/metadata.json`;

module.exports = async function (deployer, _network, accounts) {
    const [admin] = accounts;
    await deployer.deploy(MyNFTContract);
    const myNFTInstance = await MyNFTContract.deployed();
    await myNFTInstance.mintNFT(admin, IPFS_URI);
};


