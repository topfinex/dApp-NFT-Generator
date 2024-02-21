// SPDX-License-Identifier: Apache-2.0 
pragma solidity ^0.8.0;

// Smart contract for decentralized file storage using IPFS
contract IPFSFileStorage {
    // Mapping to store IPFS hashes
    mapping(bytes32 => string) private ipfsHashes;

    // Event to track file uploads
    event FileUploaded(bytes32 indexed fileId, string ipfsHash);

    // Function to upload a file to IPFS
    function uploadFile(bytes32 _fileId, string memory _ipfsHash) public {
        ipfsHashes[_fileId] = _ipfsHash;
        emit FileUploaded(_fileId, _ipfsHash);
    }

    // Function to retrieve the IPFS hash for a specific file
    function getFile(bytes32 _fileId) public view returns (string memory) {
        return ipfsHashes[_fileId];
    }
}