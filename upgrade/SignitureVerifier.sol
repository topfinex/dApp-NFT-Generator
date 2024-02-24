// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

contract SignatureVerifier {
    function verifySignature(
        bytes32 messageHash,
        uint8 v,
        bytes32 r,
        bytes32 s,
        address signer
    ) external pure returns (bool) {
        bytes32 prefixedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash));
        address recoveredSigner = ecrecover(prefixedHash, v, r, s);
        return recoveredSigner == signer;
    }
}
