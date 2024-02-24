// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract InclusionList {
    mapping(address => bool) public inclusionList;

    // EIP-712 domain separator
    bytes32 private constant DOMAIN_SEPARATOR = keccak256(
        abi.encode(
            keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
            keccak256("InclusionList"),
            keccak256("1"),
            block.chainid,
            address(this)
        )
    );

    // EIP-712 type hash for permit
    bytes32 private constant PERMIT_TYPEHASH = keccak256("Permit(address target)");

    constructor(address[] memory _initialList) {
        for (uint i = 0; i < _initialList.length; i++) {
            inclusionList[_initialList[i]] = true;
        }
    }

    function addToInclusionList(address _address) external {
        inclusionList[_address] = true;
    }

    function removeFromInclusionList(address _address) external {
        inclusionList[_address] = false;
    }

    function verify(address target, bytes memory signature) external view returns (bool) {
        bytes32 structHash = keccak256(
            abi.encode(
                PERMIT_TYPEHASH,
                target
            )
        );

        bytes32 hash = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                structHash
            )
        );

        address signer = ECDSA.recover(ECDSA.toEthSignedMessageHash(hash), signature);
        return inclusionList[signer];
    }
}
