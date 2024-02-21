// SPDX-License-Identifier: Apache-2.0 
pragma solidity ^0.8.0;

// Smart contract for generating files using IPFS
contract IPFSFileGenerator {
    // Necessary variables
    address public owner;
    mapping(bytes32 => bool) public fileExists;
    
    // Events
    event FileGenerated(bytes32 indexed fileId, string ipfsHash, address indexed sender);

    // Access control management
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function.");
        _;
    }

    // Initial setup
    constructor() {
        owner = msg.sender;
    }

    // Function for generating a file and uploading it to IPFS
    function generateFile(string memory ipfsHash) public {
        // Check for file existence based on hash
        bytes32 fileId = keccak256(abi.encodePacked(ipfsHash));
        require(!fileExists[fileId], "File already exists.");

        // Register the file and emit the FileGenerated event
        fileExists[fileId] = true;
        emit FileGenerated(fileId, ipfsHash, msg.sender);
    }

    // Function for transferring ownership of the contract
    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}