// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract MerkleProofVerifier {
    // Function to verify a Merkle proof
    function verify(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) public pure returns (bool) {
        bytes32 computedHash = leaf;

        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (computedHash < proofElement) {
                // Hash(current computed hash + current element of the proof)
                computedHash = keccak256(
                    abi.encodePacked(computedHash, proofElement)
                );
            } else {
                // Hash(current element of the proof + current computed hash)
                computedHash = keccak256(
                    abi.encodePacked(proofElement, computedHash)
                );
            }
        }

        // Check if the computed hash (root) is equal to the provided root
        return computedHash == root;
    }

    // Function to generate a Merkle root from an array of leaf nodes
    function generateRoot(
        bytes32[] memory leaves
    ) public pure returns (bytes32) {
        require(leaves.length > 0, "No leaves provided");

        if (leaves.length == 1) {
            return leaves[0];
        }

        uint256 index = 0;
        uint256 length = leaves.length;

        while (length > 1) {
            for (uint256 i = 0; i < length; i += 2) {
                if (i + 1 < length) {
                    leaves[index] = keccak256(
                        abi.encodePacked(leaves[i], leaves[i + 1])
                    );
                } else {
                    leaves[index] = leaves[i];
                }
                index++;
            }

            length = (length + 1) / 2;
        }

        return leaves[0];
    }

    // Function to generate a Merkle proof for a leaf node
    function generateProof(
        bytes32[] memory tree,
        uint256 index
    ) public pure returns (bytes32[] memory proof) {
        require(tree.length > 0, "No tree provided");
        require(index < tree.length, "Index out of bounds");

        proof = new bytes32[](tree.length - 1);
        uint256 idx = index;
        uint256 proofIdx = 0;

        for (uint256 i = 0; i < tree.length; i++) {
            if (idx % 2 == 1) {
                proof[proofIdx] = tree[i - 1];
            } else if (i < tree.length - 1) {
                proof[proofIdx] = tree[i + 1];
            }

            if (idx % 2 == 0) {
                idx = idx / 2;
            } else {
                idx = (idx + 1) / 2;
            }

            if (idx == 0) {
                break;
            }

            proofIdx++;
        }

        return proof;
    }
}