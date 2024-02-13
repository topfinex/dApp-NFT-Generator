// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../../../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../../../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    // Counter for token IDs
    uint256 private _tokenIdCounter;

    // Struct to hold metadata
    struct TokenMetadata {
        string name;
        string description;
        string imageURL;
    }

    // Mapping from token ID to TokenMetadata
    mapping(uint256 => TokenMetadata) private _tokenMetadata;

    // Constructor
    constructor() ERC721("MyNFT", "MNFT") {}

    // Function to mint a new NFT
    function mintNFT(address to, string memory name, string memory description, string memory imageURL) public onlyOwner returns (uint256) {
        uint256 tokenId = _tokenIdCounter;
        _safeMint(to, tokenId);
        _setTokenMetadata(tokenId, name, description, imageURL);
        _tokenIdCounter++;
        return tokenId;
    }

    // Internal function to set metadata for a token
    function _setTokenMetadata(uint256 tokenId, string memory name, string memory description, string memory imageURL) internal {
        TokenMetadata storage metadata = _tokenMetadata[tokenId];
        metadata.name = name;
        metadata.description = description;
        metadata.imageURL = imageURL;
    }

    // Function to get token metadata by token ID
    function getTokenMetadata(uint256 tokenId) public view returns (string memory name, string memory description, string memory imageURL) {
        require(_exists(tokenId), "Token does not exist");
        TokenMetadata memory metadata = _tokenMetadata[tokenId];
        return (metadata.name, metadata.description, metadata.imageURL);
    }

        // ERC-20
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    // ERC-1155
    function safeBatchTransferFrom(
        address _from,
        address _to,
        uint256[] calldata _ids,
        uint256[] calldata _values,
        bytes calldata _data
    ) external;
    
}


