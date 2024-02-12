pragma solidity ^0.8.0;

// Smart contract for decentralized storage using IPFS
contract IPFSStorage {
    // Mapping to store IPFS hashes
    mapping(address => string) private ipfsHashes;

    // Event to track file uploads
    event FileUploaded(address indexed user, string ipfsHash);

    // Function to upload a file to IPFS
    function uploadFile(string memory _ipfsHash) public {
        ipfsHashes[msg.sender] = _ipfsHash;
        emit FileUploaded(msg.sender, _ipfsHash);
    }

    // Function to retrieve the IPFS hash for a specific user
    function getFile(address _user) public view returns (string memory) {
        return ipfsHashes[_user];
    }
}
