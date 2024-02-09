// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

// Import the necessary Ethereum interfaces
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract MetadataReceiver {
    // Address of the ERC721 contract
    address private nftContract;

    // Mapping to store metadata by token ID
    mapping(uint256 => string) private metadata;

    // Event to emit when metadata is set
    event MetadataSet(uint256 indexed tokenId, string metadata);

    // Constructor to set the address of the ERC721 contract
    constructor(address _nftContract) {
        nftContract = _nftContract;
    }

    // Function to set metadata for a specific token ID
    function setMetadata(uint256 tokenId, string memory _metadata) external {
        // Check if the caller is the owner of the token
        require(msg.sender == IERC721(nftContract).ownerOf(tokenId), "Caller is not the owner of the token");

        // Set the metadata for the token
        metadata[tokenId] = _metadata;

        // Emit an event
        emit MetadataSet(tokenId, _metadata);
    }

    // Function to get metadata for a specific token ID
    function getMetadata(uint256 tokenId) external view returns (string memory) {
        return metadata[tokenId];
    }
}