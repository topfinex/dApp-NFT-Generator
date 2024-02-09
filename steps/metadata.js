const { Network, Alchemy } = require("alchemy-sdk");

const settings = {
    apiKey: "0xe785E82358879F061BC3dcAC6f0444462D4b5330",
    network: Network.ETH_MAINNET,
};
const alchemy = new Alchemy(settings);

async function getNFTMetadata(nftContractAddress, tokenId) {
    const response = await alchemy.nft.getNftMetadata(
        nftContractAddress,
        tokenId
    );
    return response;
}

async function main() {
    const response = await getNFTMetadata(
        "0xe785E82358879F061BC3dcAC6f0444462D4b5330",
        "44"
    );
    console.log("NFT Metadata:\n", response);
}

main();