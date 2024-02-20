// UpgradedMyContract.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./contract.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract UpgradedMyContract is MyContract {
    function initialize(uint256 _value) public override initializer {
        value = _value * 2; // Example of modification in the upgraded contract
    }
}
